---
name: tuimessenger
description: Use when the user asks about their messages, chats, DMs, or conversations — WhatsApp, Telegram, Slack, Instagram, or tuimessenger. Covers searching history, exporting a chat, message counts, activity stats, and who said what. Reads the local tuimessenger backend's SQLite store read-only. Also use to send/text someone a message — always via the running tuimessenger backend's Matrix API with the agent token (never the TUI).
---

# tuimessenger message access

tuimessenger runs the WhatsApp, Telegram, Slack and Instagram bridges locally (launchd
`com.whyyor.tuimessenger`, API on `127.0.0.1:8008`). Everything bridged is in its store:

```sh
S="file:$HOME/Library/Application Support/tuimessenger/store.db?mode=ro"
```

**Always use `?mode=ro`.** The backend holds this DB open with a live WAL; writing to it can
corrupt it. Nothing is encrypted, so `content` is always the real content.

The user is `@me:tuimessenger.localhost`. Other people are bridge "ghosts" like
`@whatsapp_lid-2035…`, `@telegram_123…`, `@slack_…`, `@instagram_…`; bots end in `bot`.

## Rules that silently break queries

1. **Rooms have no name column.** Only group chats have an `m.room.name` state event; a DM's
   name is the other member's display name. Use the `rooms` CTE below.
2. **Deleted messages are still in `local_events`.** A deletion is a separate `m.room.redaction`
   event whose `redacts` column is the deleted event's ID. Exclude those (see `NOT EXISTS` below).
3. **Edits are extra `m.room.message` events** with `m.relates_to.rel_type = 'm.replace'` (new text
   in `m.new_content`). Exclude them, or you'll see every message twice.
4. **Timestamps are milliseconds**; divide by 1000 for `datetime()`.
5. There is **no full-text index**: search with `LIKE` on `json_extract(content,'$.body')`.

## Names: paste this CTE in front of queries

```sql
WITH rn AS (
  SELECT cs.room_id, json_extract(e.content,'$.name') AS name
  FROM local_current_state cs JOIN local_events e ON e.event_id = cs.event_id
  WHERE cs.type = 'm.room.name'),
members AS (
  SELECT cs.room_id, group_concat(COALESCE(json_extract(e.content,'$.displayname'), cs.state_key), ', ') AS name
  FROM local_current_state cs JOIN local_events e ON e.event_id = cs.event_id
  WHERE cs.type = 'm.room.member' AND json_extract(e.content,'$.membership') = 'join'
    AND cs.state_key NOT LIKE '@me:%' AND cs.state_key NOT GLOB '@*bot:*'
  GROUP BY cs.room_id),
rooms AS (
  SELECT DISTINCT e.room_id, COALESCE(rn.name, substr(m.name,1,40), e.room_id) AS room
  FROM local_events e LEFT JOIN rn USING (room_id) LEFT JOIN members m USING (room_id))
```

Sender names: `local_profiles(user_id, displayname)` holds each ghost's current name.

## Recent messages

```sh
sqlite3 -header -column "$S" "
WITH ... -- the CTE above
SELECT datetime(e.timestamp/1000,'unixepoch','localtime') AS ts, r.room,
       CASE WHEN e.sender LIKE '@me:%' THEN 'me' ELSE COALESCE(p.displayname, e.sender) END AS sender,
       json_extract(e.content,'\$.body') AS body
FROM local_events e JOIN rooms r USING (room_id)
LEFT JOIN local_profiles p ON p.user_id = e.sender
WHERE e.type IN ('m.room.message','m.sticker')
  AND json_extract(e.content,'\$.\"m.relates_to\".rel_type') IS NOT 'm.replace'
  AND NOT EXISTS (SELECT 1 FROM local_events x WHERE x.type='m.room.redaction' AND x.redacts=e.event_id)
ORDER BY e.timestamp DESC LIMIT 20;"
```

## Search

Same query with an extra condition, e.g.
`AND json_extract(e.content,'\$.body') LIKE '%invoice%'`. Case-insensitive for ASCII only.

## Find a chat, then export it

```sh
sqlite3 -header -column "$S" "WITH ... SELECT room_id, room FROM rooms WHERE room LIKE '%kunal%';"
```

Then reuse the recent-messages query with `AND e.room_id='!ROOM_ID'` and `ORDER BY e.timestamp`
(no LIMIT).

Which network a room is on: its `m.bridge` state event,
`json_extract(content,'$.protocol.id')` (`whatsapp`, `telegram`, `slackgo`, `instagramgo`).

## Older history

The store only has what was bridged: about the last 20 messages per chat at first, more after
the user scrolled up in the TUI. If something older is needed, say so instead of concluding it
doesn't exist.

## Sending messages — via the backend API, with the agent token

The agent has its own login (device `TMAGENT`), so the user's own sessions are never touched.
Token: `~/Library/Application Support/tuimessenger/agent-token` (0600). **Read it inside the
command; never print it.** Revoke by deleting the `TMAGENT` row from `access_tokens` (only with
the user's OK).

```sh
TOKEN=$(cat "$HOME/Library/Application Support/tuimessenger/agent-token")
BODY=$(python3 -c 'import json,sys;print(json.dumps({"msgtype":"m.text","body":sys.argv[1]}))' 'message text')
ROOM=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))' '!ROOM_ID:tuimessenger.localhost')
curl -s -X PUT -H "Authorization: Bearer $TOKEN" -H 'Content-Type: application/json' -d "$BODY" \
  "http://127.0.0.1:8008/_matrix/client/v3/rooms/$ROOM/send/m.room.message/agent-$(date +%s%N)" -w '\nHTTP %{http_code}\n'
```

The answer is `{"event_id":"$…"}`. If the network refuses the message, the API answers
`M_FORBIDDEN` (or an error) and nothing is sent.

Workflow: find the room via SQLite → show the user the exact final text + recipient → send
ONLY after explicit confirmation → verify.

**Verify delivery** with the bridge's status event for that event ID:

```sh
sqlite3 "$S" "SELECT json_extract(content,'\$.status'), json_extract(content,'\$.delivered_to_users')
FROM local_events WHERE type='com.beeper.message_send_status'
  AND json_extract(content,'\$.\"m.relates_to\".event_id')='\$EVENT_ID' ORDER BY pos DESC LIMIT 1;"
```

`SUCCESS` with `delivered_to_users` = delivered through the bridge.

## If the backend isn't running

`launchctl print gui/$(id -u)/com.whyyor.tuimessenger | grep state`; logs in
`~/Library/Logs/tuimessenger/tuimessenger.log`. Reading the store works even when it's stopped.

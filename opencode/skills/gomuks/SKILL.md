---
name: gomuks
description: Use when the user asks about their messages, chats, DMs, or conversations — Matrix, Beeper, WhatsApp, Telegram, iMessage, Instagram, or gomuks. Covers searching history, exporting a room, message counts, activity stats, and who said what. Reads the local gomuks SQLite cache read-only.
---

# gomuks message access

Local Beeper/Matrix history for `@whyyor:beeper.com` is cached in SQLite.
Read it directly; it is the fastest route and needs no auth.

```sh
GM="file:$HOME/Library/Application Support/gomuks/gomuks.db?mode=ro"
```

**Always use `?mode=ro`.** The gomuks daemon holds this DB open with a live
WAL; writing to it can corrupt the running client's state.

## Three rules that will silently break queries

1. **E2EE content lives in a different column.** gomuks stores decrypted
   messages in `decrypted`, plaintext ones in `content`. Always
   `COALESCE(decrypted, content)` and `COALESCE(decrypted_type, type)`.
   Skipping this makes encrypted rooms return NULL — thousands of messages
   look like zero.
2. **`event_search` is a contentless FTS5 table.** Selecting its columns
   returns empty strings. `MATCH` against it, then join back to `event` on
   rowid to read the real text.
3. **Filter `redacted_by IS NULL`** or you resurrect deleted messages.

## Recent messages

```sh
sqlite3 -header -column "$GM" "
SELECT datetime(e.timestamp/1000,'unixepoch','localtime') AS ts,
       COALESCE(r.name, r.dm_user_id) AS room,
       e.sender,
       json_extract(COALESCE(e.decrypted,e.content),'\$.body') AS body
FROM event e JOIN room r USING(room_id)
WHERE COALESCE(e.decrypted_type,e.type)='m.room.message'
  AND e.redacted_by IS NULL
ORDER BY e.timestamp DESC LIMIT 20;"
```

## Full-text search

```sh
sqlite3 -header -column "$GM" "
SELECT datetime(e.timestamp/1000,'unixepoch','localtime') AS ts,
       COALESCE(r.name, r.dm_user_id) AS room,
       json_extract(COALESCE(e.decrypted,e.content),'\$.body') AS body
FROM event_search s
JOIN event e ON e.rowid = s.rowid
JOIN room r ON r.room_id = e.room_id
WHERE event_search MATCH 'invoice OR payment'
  AND e.redacted_by IS NULL
ORDER BY e.timestamp DESC LIMIT 30;"
```

FTS5 syntax: `foo AND bar`, `foo OR bar`, `NOT foo`, `"exact phrase"`,
`pref*`. Tokenizer is porter-stemmed, so `meeting` also matches `meet`.

## Export one room

Find the room first, then dump it.

```sh
sqlite3 -header -column "$GM" \
  "SELECT room_id, name, dm_user_id FROM room WHERE name LIKE '%kunal%';"
```

```sh
sqlite3 "$GM" "
SELECT datetime(e.timestamp/1000,'unixepoch','localtime') || '  ' ||
       e.sender || ': ' ||
       json_extract(COALESCE(e.decrypted,e.content),'\$.body')
FROM event e
WHERE e.room_id='!ROOM_ID_HERE'
  AND COALESCE(e.decrypted_type,e.type)='m.room.message'
  AND e.redacted_by IS NULL
ORDER BY e.timestamp;"
```

## Resolving bridge IDs to human names

Senders look like `@whatsapp_lid-852381...`. Map them via member state:

```sh
sqlite3 -header -column "$GM" "
SELECT cs.state_key AS mxid,
       json_extract(COALESCE(e.decrypted,e.content),'\$.displayname') AS name
FROM current_state cs JOIN event e ON e.rowid = cs.event_rowid
WHERE cs.event_type='m.room.member' AND cs.room_id='!ROOM_ID_HERE';"
```

## Schema notes

- `room` — `name`, `dm_user_id`, `topic`, `unread_messages`, `sorting_timestamp`.
  Display name: `COALESCE(name, dm_user_id, room_id)`.
- `event` — one row per event. `reactions` is a JSON blob; `relates_to` +
  `relation_type` cover replies, edits, threads. `last_edit_rowid` points at
  the newest edit.
- Non-message types worth knowing: `m.reaction`, `m.room.member`,
  `m.room.encrypted` (rows where `decrypted IS NULL` failed to decrypt).
- Timestamps are **milliseconds**; divide by 1000 for `datetime()`.

## Limits

Read-only cache. Cannot send messages and only holds synced history — for
sending or server-side backfill you'd need the gomuks HTTP API on
`127.0.0.1:29325`, which requires auth from `config.yaml`.

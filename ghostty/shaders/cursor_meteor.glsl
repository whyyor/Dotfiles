// Meteor cursor: the block glides to its target while a tapered, fading tail
// with a white-hot core, soft glow and sparkles streaks behind it.
//
//     cursor-opacity = 0
//     custom-shader  = shaders/cursor_meteor.glsl

const float DURATION        = 0.20;  // seconds for the head to arrive
const float TAIL_DURATION   = 0.26;  // tail waits at the start, then catches up
const float TAIL_LENGTH     = 0.85;   // streak length multiplier (1.0 = full)
const float BALL_SIZE       = 1.0;   // ball diameter as a fraction of the cell's narrow side
const float BALL_MORPH_START = 0.6;  // fraction of head travel after which the ball turns back into a block
const float BALL_SOFT       = 0.5;   // how much of the ball radius fades out (0 = hard edge)
const float HEAD_GLOW       = 0.5;   // halo strength around the ball in flight
const float HEAD_GLOW_PX    = 8.0;   // halo falloff distance (px)
const float HEAD_WIDTH      = 0.8;   // tail width at the head, as a fraction of block height
const float MIN_DIST        = 8.0;   // tail length (px) over which the trail/ball fades in and out
const float CELL_ASPECT     = 0.45;  // cell width / height, used to size bar & underline cursors
const vec2  MIN_CELLS       = vec2(4.0, 1.5);  // (cols, rows) a move must exceed to become a meteor
const float SMEAR_DURATION  = 0.25;  // short-move smear: seconds for the trailing edge to arrive
const float SMEAR_LEAD      = 1.25;  // short-move smear: leading edge speed multiplier
const float SMEAR_EASE_POW  = 4.0;   // short-move smear easing (lower = softer, 4.0 = old snappy feel)
const float TAIL_R          = 0.5;   // radius of the tail tip in pixels
const float FADE_POW        = 1.6;   // higher = tail fades faster
const float GLOW_PX         = 4.0;   // halo falloff distance
const float GLOW_STRENGTH   = 0.25;
const float CORE_WHITE      = 0.0;   // how white-hot the centre line gets
const float SPARKLE         = 1.0;   // 0 disables sparkles
const float SPARKLE_DENSITY = 0.965; // higher = fewer sparkles
const float SPARKLE_SPREAD  = 10.0;  // how far sparkles scatter outside the tail (px)
const float SPARKLE_PX      = 2.0;   // sparkle size
const float BG_OPACITY      = 0.20;  // must match background-opacity
const float AA              = 1.0;   // edge antialiasing in pixels
const float GLYPH_DARKEN    = 0.22;  // glyph brightness under the block
const float HOLLOW_T        = 2.0;   // unfocused outline thickness in pixels
const float GLYPH_REF       = 0.8;   // colour-mask contrast scale for app-painted cells

float ease(float x) { return 1.0 - pow(1.0 - x, 4.0); }
float easeSmear(float x) { return 1.0 - pow(1.0 - x, SMEAR_EASE_POW); }

float hash(vec2 p) { return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453); }

float sdfRect(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Segment a->b whose radius goes ra->rb; h is 0 at a, 1 at b.
float sdTaper(vec2 p, vec2 a, vec2 b, float ra, float rb, out float h, out float axis) {
    vec2 pa = p - a, ba = b - a;
    h = clamp(dot(pa, ba) / max(dot(ba, ba), 1e-6), 0.0, 1.0);
    axis = length(pa - ba * h);
    return axis - mix(ra, rb, h);
}

vec2 rectCenter(vec4 r) { return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5); }

// Short-move smear (from cursor_smear.glsl): hexagon spanning the lagging and leading block.
void edge(vec2 p, vec2 a, vec2 b, inout float d, inout float inside) {
    vec2 e = b - a, pa = p - a;
    float h = clamp(dot(pa, e) / max(dot(e, e), 1e-6), 0.0, 1.0);
    vec2 q = pa - e * h;
    d = min(d, dot(q, q));
    inside = min(inside, step(0.0, e.x * pa.y - e.y * pa.x));
}

float sdfHex(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3, vec2 v4, vec2 v5) {
    float d = 1e20, inside = 1.0;
    edge(p, v0, v1, d, inside); edge(p, v1, v2, d, inside);
    edge(p, v2, v3, d, inside); edge(p, v3, v4, d, inside);
    edge(p, v4, v5, d, inside); edge(p, v5, v0, d, inside);
    float s = sqrt(d);
    return mix(s, -s, inside);
}

struct Quad { vec2 tl; vec2 tr; vec2 bl; vec2 br; };

Quad getQuad(vec2 pos, vec2 size) {
    return Quad(pos, pos + vec2(size.x, 0.0), pos - vec2(0.0, size.y), pos + vec2(size.x, -size.y));
}

void trailCorners(Quad q, vec2 s, out vec2 p1, out vec2 p2, out vec2 p3) {
    p1 = mix(mix(q.tr, q.tl, s.x), mix(q.br, q.bl, s.x), s.y);
    p2 = mix(mix(q.tl, q.bl, s.x), mix(q.tr, q.br, s.x), s.y);
    p3 = mix(mix(q.br, q.tr, s.x), mix(q.bl, q.tl, s.x), s.y);
}

vec2 leadCorner(Quad q, vec2 s) {
    return mix(mix(q.bl, q.br, s.x), mix(q.tl, q.tr, s.x), s.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 tex = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = tex;

    if (iCursorVisible == 0) return;
    vec4 cur = iCurrentCursor;

    // Unfocused (or hollow/lock style): outline only, glyph keeps its own colour.
    if (iFocus == 0 || iCurrentCursorStyle == CURSORSTYLE_BLOCK_HOLLOW ||
        iCurrentCursorStyle == CURSORSTYLE_LOCK) {
        float outer = sdfRect(fragCoord, rectCenter(cur), cur.zw * 0.5);
        float ring  = max(outer, -(outer + HOLLOW_T));
        float cov   = 1.0 - smoothstep(0.0, AA, ring);
        fragColor   = mix(tex, vec4(iCurrentCursorColor.rgb, 1.0), cov);
        return;
    }

    vec4 prev = iPreviousCursor;
    if (dot(prev.zw, prev.zw) == 0.0) prev = cur;  // first frame: don't fly in from the corner

    float elapsed = iTime - iTimeCursorChange;
    float eHead   = ease(clamp(elapsed / DURATION, 0.0, 1.0));
    float eTail   = pow(clamp(elapsed / TAIL_DURATION, 0.0, 1.0), 2.0);

    vec2 p0   = rectCenter(prev);
    vec2 p1   = rectCenter(cur);
    vec2 head = mix(p0, p1, eHead);
    vec2 tail = mix(head, mix(p0, p1, eTail), TAIL_LENGTH);  // pull the tail toward the head
    vec2 size = mix(prev.zw, cur.zw, eHead);
    vec3 col  = mix(iPreviousCursorColor.rgb, iCurrentCursorColor.rgb, eHead);

    vec2  dir    = head - tail;
    float len    = length(dir);
    // Bar/underline cursors are thin, so estimate the real cell size from the long side.
    vec2 cell = cur.zw;
    if (iCurrentCursorStyle == CURSORSTYLE_BAR)       cell.x = cur.w * CELL_ASPECT;
    if (iCurrentCursorStyle == CURSORSTYLE_UNDERLINE) cell.y = cur.z / CELL_ASPECT;

    bool  flying = any(greaterThan(abs(p1 - p0), cell * MIN_CELLS));  // fast typing can jump 2-3 cells per frame
    float alive  = flying ? smoothstep(0.0, MIN_DIST, len) : 0.0;  // 1 while the tail shows, 0 at rest

    // Morph block -> ball in flight, back to a block as the head lands (not when the tail catches up).
    float ballAmt = min(alive, 1.0 - smoothstep(BALL_MORPH_START, 1.0, clamp(elapsed / DURATION, 0.0, 1.0)));
    float ballR  = min(cell.x, cell.y) * 0.5 * BALL_SIZE;  // cell-sized ball even for a bar cursor
    float corner = ballR * ballAmt;
    vec2  halfB  = mix(size * 0.5, vec2(ballR), ballAmt);
    float dBall  = sdfRect(fragCoord, head, halfB - corner) - corner;
    float edgeW  = mix(AA, max(AA, ballR * BALL_SOFT), ballAmt);  // soft orb edge only while it's a ball
    float block  = 1.0 - smoothstep(AA - edgeW, AA, dBall);
    float halo   = exp(-max(dBall, 0.0) / HEAD_GLOW_PX) * HEAD_GLOW * ballAmt;

    // Short moves: the old stretchy smear instead of a sliding block.
    if (!flying) {
        float t  = clamp(elapsed / SMEAR_DURATION, 0.0, 1.0);
        float eB = easeSmear(t);
        float eF = easeSmear(min(t * SMEAR_LEAD, 1.0));
        vec2  sel   = step(vec2(0.0), cur.xy - prev.xy);
        Quad  back  = getQuad(mix(prev.xy, cur.xy, eB), mix(prev.zw, cur.zw, eB));
        Quad  front = getQuad(mix(prev.xy, cur.xy, eF), mix(prev.zw, cur.zw, eF));
        vec2 b1, b2, b3, f1, f2, f3;
        trailCorners(back, sel, b1, b2, b3);
        trailCorners(front, sel, f1, f2, f3);
        block = 1.0 - smoothstep(0.0, AA, sdfHex(fragCoord, b1, b2, f2, leadCorner(front, sel), f3, b3));
        col   = mix(iPreviousCursorColor.rgb, iCurrentCursorColor.rgb, eF);
    }

    float trail = 0.0, hot = 0.0;
    if (flying && len > 0.5) {
        vec2  n       = dir / len;
        vec2  perp    = vec2(-n.y, n.x);
        float rAcross = 0.5 * (abs(perp.x) * size.x + abs(perp.y) * size.y);
        float rHead   = min(rAcross * HEAD_WIDTH, ballR);  // tail meets the ball, never wider

        float h, axis;
        float d     = sdTaper(fragCoord, tail, head, TAIL_R, rHead, h, axis);
        float fade  = pow(h, FADE_POW);

        float body = (1.0 - smoothstep(0.0, AA, d)) * fade;
        float glow = exp(-max(d, 0.0) / GLOW_PX) * GLOW_STRENGTH * fade
                   * (1.0 - smoothstep(0.85, 1.0, h));  // no halo ball around the head
        float core = 1.0 - smoothstep(0.0, max(mix(TAIL_R, rHead, h) * 0.6, 1.0), axis);

        trail = max(max(body, glow) * alive, halo);
        hot   = core * body * alive;

        if (SPARKLE > 0.0 && d < SPARKLE_SPREAD && h < 0.95) {
            float s  = hash(floor(fragCoord / SPARKLE_PX) + floor(iTime * 40.0));
            float sp = step(SPARKLE_DENSITY, s) * (1.0 - smoothstep(0.0, SPARKLE_SPREAD, d))
                     * smoothstep(0.0, 0.3, h) * alive * SPARKLE;
            trail = max(trail, sp * 0.9);
            hot   = max(hot, sp);
        }
    }

    if (trail <= 0.0 && block <= 0.0) return;

    vec3 trailCol = mix(col, vec3(1.0), hot * CORE_WHITE);
    vec4 base     = mix(tex, vec4(trailCol, 1.0), clamp(trail, 0.0, 1.0));

    // Keep the destination cell's glyph on top of the block.
    float inTarget = 1.0 - step(0.0, sdfRect(fragCoord, p1, cur.zw * 0.5));

    // Apps that paint their own cell background (opencode, nvim) make the whole
    // cell opaque, so fall back to colour distance there.
    vec4  c1 = texture(iChannel0, (cur.xy + vec2(1.5, -1.5)) / iResolution.xy);
    vec4  c2 = texture(iChannel0, (cur.xy + vec2(cur.z - 1.5, -1.5)) / iResolution.xy);
    vec3  cellBg  = (c1.rgb + c2.rgb) * 0.5;
    float painted = step(BG_OPACITY + 0.03, min(c1.a, c2.a));

    float byAlpha  = smoothstep(min(BG_OPACITY, 0.999), 1.0, tex.a);
    float byColour = clamp(distance(tex.rgb, cellBg) /
                     max(distance(iForegroundColor, cellBg) * GLYPH_REF, 0.02), 0.0, 1.0);
    float text     = mix(byAlpha, byColour, painted) * inTarget;

    vec4 blockCol = mix(vec4(col, 1.0), vec4(tex.rgb * GLYPH_DARKEN, 1.0), text);
    fragColor = mix(base, blockCol, block);
}

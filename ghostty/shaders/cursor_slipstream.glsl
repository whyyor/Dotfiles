// Slipstream cursor: short moves (typing) get a stretchy smear; long jumps snap the
// block to its target while a warp quad stretches in, each corner arriving at its own pace.
//
//     cursor-opacity = 0
//     custom-shader  = shaders/cursor_slipstream.glsl

// Warp trail (long jumps)
const float WARP_DURATION = 0.20;  // seconds for the trailing corners to arrive
const float WARP_SIZE     = 0.8;   // 0 = corners move together, 1 = leading corners jump instantly
const float WARP_THICK    = 1.0;   // trail height as a fraction of the cursor
const float WARP_THICK_X  = 0.9;   // trail width as a fraction of the cursor
const float WARP_FADE     = 0.0;   // 0 = solid, >0 = fade exponent along the trail (try 5.0)

// Smear (short moves / typing)
const float SMEAR_MIN_DURATION = 0.25;  // 1-cell moves (typing)
const float SMEAR_MAX_DURATION = 0.25;  // multi-cell moves
const float SMEAR_FULL_CELLS   = 4.0;   // distance (in cells) that gets the full duration
const float SMEAR_LEAD     = 1.4;   // leading edge speed multiplier
const float SMEAR_EASE_POW = 3.0;   // easing curve (lower = softer)

// Jump detection
const vec2  MIN_CELLS      = vec2(4.0, 1.5);  // (cols, rows) a move must exceed to become a jump
const float CELL_ASPECT    = 0.45;  // cell width / height, used to size bar & underline cursors

// Drawing
const float BG_OPACITY     = 0.20;  // must match background-opacity
const float AA             = 1.0;   // edge antialiasing in pixels
const float GLYPH_DARKEN   = 0.22;  // glyph brightness under the block
const float HOLLOW_T       = 2.0;   // unfocused outline thickness in pixels
const float GLYPH_REF      = 0.8;   // colour-mask contrast scale for app-painted cells

float easeOut(float x, float p) { return 1.0 - pow(1.0 - x, p); }

vec2 rectCenter(vec4 r) { return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5); }

float sdfRect(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Smear hexagon spanning the lagging and leading block.
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


float easeCirc(float x) { return sqrt(1.0 - (x - 1.0) * (x - 1.0)); }

// Convex quad, vertices counter-clockwise.
float sdfQuad(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float d = 1e20, inside = 1.0;
    edge(p, v0, v1, d, inside); edge(p, v1, v2, d, inside);
    edge(p, v2, v3, d, inside); edge(p, v3, v0, d, inside);
    float s = sqrt(d);
    return mix(s, -s, inside);
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
    vec2  p0 = rectCenter(prev);
    vec2  p1 = rectCenter(cur);

    // Bar/underline cursors are thin, so estimate the real cell size from the long side.
    vec2 cell = cur.zw;
    if (iCurrentCursorStyle == CURSORSTYLE_BAR)       cell.x = cur.w * CELL_ASPECT;
    if (iCurrentCursorStyle == CURSORSTYLE_UNDERLINE) cell.y = cur.z / CELL_ASPECT;
    bool jump = any(greaterThan(abs(p1 - p0), cell * MIN_CELLS));  // fast typing can jump 2-3 cells per frame

    vec3  col;
    float block;
    vec4  base = tex;

    if (jump) {
        // Block lands instantly; a warp quad stretches from the old cell to the new one.
        col   = iCurrentCursorColor.rgb;
        block = 1.0 - smoothstep(0.0, AA, sdfRect(fragCoord, p1, cur.zw * 0.5));

        if (elapsed < WARP_DURATION) {
            vec2  s     = sign(p1 - p0);
            float dLead = WARP_DURATION * (1.0 - WARP_SIZE);
            float dSide = (dLead + WARP_DURATION) * 0.5;
            vec2  hp    = prev.zw * 0.5 * vec2(WARP_THICK_X, WARP_THICK);
            vec2  hc    = cur.zw  * 0.5 * vec2(WARP_THICK_X, WARP_THICK);
            vec2  dirs[4] = vec2[4](vec2(-1.0, -1.0), vec2(1.0, -1.0), vec2(1.0, 1.0), vec2(-1.0, 1.0));  // bl, br, tr, tl
            float railR = (dot(dirs[1], s) + dot(dirs[2], s)) * 0.5;
            float railL = (dot(dirs[0], s) + dot(dirs[3], s)) * 0.5;
            vec2  v[4];
            for (int i = 0; i < 4; i++) {
                float dd = dot(dirs[i], s);
                if (s.x >  0.5 && dirs[i].x > 0.0) dd = railR;  // leading edge moves as one rail
                if (s.x < -0.5 && dirs[i].x < 0.0) dd = railL;
                float dur = dd >= 0.5 ? dLead : (dd >= -0.5 ? dSide : WARP_DURATION);
                v[i] = mix(p0 + dirs[i] * hp, p1 + dirs[i] * hc, easeCirc(clamp(elapsed / dur, 0.0, 1.0)));
            }
            float amount = 1.0 - smoothstep(0.0, AA, sdfQuad(fragCoord, v[0], v[1], v[2], v[3]));
            if (WARP_FADE > 0.0) {
                vec2 mv = p1 - p0;
                amount *= pow(clamp(dot(fragCoord - p0, mv) / max(dot(mv, mv), 1e-6), 0.0, 1.0), WARP_FADE);
            }
            base = mix(tex, vec4(col, 1.0), amount);
        }
    } else {
        // Short moves: stretchy smear between the lagging and leading block.
        float cells = length((p1 - p0) / cell);
        float dur   = mix(SMEAR_MIN_DURATION, SMEAR_MAX_DURATION,
                          smoothstep(1.0, SMEAR_FULL_CELLS, cells));
        float t  = clamp(elapsed / dur, 0.0, 1.0);
        float eB = easeOut(t, SMEAR_EASE_POW);
        float eF = easeOut(min(t * SMEAR_LEAD, 1.0), SMEAR_EASE_POW);
        vec2  sel   = step(vec2(0.0), cur.xy - prev.xy);
        Quad  back  = getQuad(mix(prev.xy, cur.xy, eB), mix(prev.zw, cur.zw, eB));
        Quad  front = getQuad(mix(prev.xy, cur.xy, eF), mix(prev.zw, cur.zw, eF));
        vec2 b1, b2, b3, f1, f2, f3;
        trailCorners(back, sel, b1, b2, b3);
        trailCorners(front, sel, f1, f2, f3);
        if (iCurrentCursorStyle == CURSORSTYLE_BAR || iCurrentCursorStyle == CURSORSTYLE_UNDERLINE) {
            vec2 c = rectCenter(vec4(mix(prev.xy, cur.xy, eF), cur.zw));  // thin cursors slide, never stretch
            block = 1.0 - smoothstep(0.0, AA, sdfRect(fragCoord, c, cur.zw * 0.5));
        } else {
            block = 1.0 - smoothstep(0.0, AA, sdfHex(fragCoord, b1, b2, f2, leadCorner(front, sel), f3, b3));
        }
        col   = mix(iPreviousCursorColor.rgb, iCurrentCursorColor.rgb, eF);
    }

    fragColor = base;
    if (block <= 0.0) return;

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

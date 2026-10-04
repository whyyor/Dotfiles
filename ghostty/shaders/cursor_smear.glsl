// Glide cursor that smears on long jumps: the leading edge arrives first and
// the trailing edge catches up, so short moves glide and pane jumps stretch.
//
//     cursor-opacity = 0
//     custom-shader  = shaders/cursor_smear.glsl

const float DURATION   = 0.20;  // seconds for the trailing edge to arrive
const float LEAD       = 1.25;   // leading edge speed multiplier
const float BG_OPACITY = 0.80;  // must match background-opacity
const float AA         = 1.0;   // edge antialiasing in pixels
const float GLYPH_DARKEN = 0.22; // glyph brightness under the block (lower = darker)
const float HOLLOW_T   = 2.0;   // unfocused outline thickness in pixels
const float GLYPH_REF  = 0.8;   // colour-mask contrast scale for app-painted cells

// macOS `alpha-blending = native`: colors arrive non-linear, no conversion.

float ease(float x) { return 1.0 - pow(1.0 - x, 4.0); }

float sdfRect(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 rectCenter(vec4 r) { return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5); }

void edge(vec2 p, vec2 a, vec2 b, inout float d, inout float inside) {
    vec2 e = b - a, pa = p - a;
    float h = clamp(dot(pa, e) / max(dot(e, e), 1e-6), 0.0, 1.0);  // guard zero-length edges
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

// Corner picking from the trail shader: sel.x 0=left 1=right, sel.y 0=top 1=bottom.
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

    float t      = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float eBack  = ease(t);
    float eFront = ease(min(t * LEAD, 1.0));

    vec2 sel   = step(vec2(0.0), cur.xy - prev.xy);
    Quad back  = getQuad(mix(prev.xy, cur.xy, eBack),  mix(prev.zw, cur.zw, eBack));
    Quad front = getQuad(mix(prev.xy, cur.xy, eFront), mix(prev.zw, cur.zw, eFront));

    vec2 b1, b2, b3, f1, f2, f3;
    trailCorners(back, sel, b1, b2, b3);
    trailCorners(front, sel, f1, f2, f3);
    vec2 f4 = leadCorner(front, sel);

    float d = sdfHex(fragCoord, b1, b2, f2, f4, f3, b3);
    float coverage = 1.0 - smoothstep(0.0, AA, d);
    if (coverage <= 0.0) return;

    vec4 cursor = vec4(mix(iPreviousCursorColor.rgb, iCurrentCursorColor.rgb, eFront), 1.0);

    // Keep the destination cell's glyph on top of the block, same as the glide.
    float inTarget = 1.0 - step(0.0, sdfRect(fragCoord, rectCenter(cur), cur.zw * 0.5));

    // Apps that paint their own cell background (opencode, nvim) make the whole
    // cell opaque, so alpha can't separate glyph from background there. Detect
    // that from the top corners and fall back to colour distance.
    vec4  c1 = texture(iChannel0, (cur.xy + vec2(1.5, -1.5)) / iResolution.xy);
    vec4  c2 = texture(iChannel0, (cur.xy + vec2(cur.z - 1.5, -1.5)) / iResolution.xy);
    vec3  cellBg  = (c1.rgb + c2.rgb) * 0.5;
    float painted = step(BG_OPACITY + 0.03, min(c1.a, c2.a));

    float byAlpha  = smoothstep(min(BG_OPACITY, 0.999), 1.0, tex.a);
    float byColour = clamp(distance(tex.rgb, cellBg) /
                     max(distance(iForegroundColor, cellBg) * GLYPH_REF, 0.02), 0.0, 1.0);
    float text     = mix(byAlpha, byColour, painted) * inTarget;
    fragColor = mix(tex, mix(cursor, vec4(tex.rgb * GLYPH_DARKEN, 1.0), text), coverage);
}

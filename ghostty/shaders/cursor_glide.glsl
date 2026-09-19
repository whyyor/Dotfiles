// the cursor itself glides between cells instead of jumping.
// Unlike a trail shader, this one is the focused cursor, so it
// requires ghostty's own cursor to be hidden:
//
//     cursor-opacity = 0
//     custom-shader  = "./shaders/cursor_glide.glsl"

// --- CONFIGURATION ---
const float DURATION   = 0.10;  // seconds for one glide
const float AA         = 1.0;   // edge antialiasing in pixels
const float HOLLOW_T   = 2.0;   // unfocused border thickness in pixels
const float GLYPH_DARKEN = 0.22;  // how far to darken the glyph under a light cursor
const float GLYPH_EDGE0  = 0.06;  // colour distance from cell bg that starts counting as glyph
const float GLYPH_EDGE1  = 0.22;  // ...and where it counts fully
const bool  DEBUG_MASK   = false; // true = render the glyph mask instead of the cursor

// NOTE: macOS defaults to `alpha-blending = native`, so ghostty hands this
// shader non-linear colors and expects non-linear output -- no conversion.
// On linux (default `linear-corrected`) you'd need an sRGB->linear step here.

// EaseOutCubic
float ease(float x) {
    return 1.0 - pow(1.0 - x, 4.0);
}

float sdfRect(vec2 p, vec2 center, vec2 halfSize) {
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// iCurrentCursor/iPreviousCursor are (left, top-edge, width, height) in
// pixels with shadertoy's y-up convention: the rect spans [y - h, y].
vec2 rectCenter(vec4 r) {
    return vec2(r.x + r.z * 0.5, r.y - r.w * 0.5);
}

vec3 texAt(vec2 p) { return texture(iChannel0, p / iResolution.xy).rgb; }

// Median of 4 (mean of the middle two): one or two corners landing on glyph ink
// get rejected, so a tall or underlined character can't poison the estimate.
vec3 med4(vec3 a, vec3 b, vec3 c, vec3 d) {
    vec3 mx = max(max(a, b), max(c, d));
    vec3 mn = min(min(a, b), min(c, d));
    return (a + b + c + d - mx - mn) * 0.5;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 tex = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = tex;

    if (iCursorVisible == 0) return;

    vec4 cur = iCurrentCursor;

    // Unfocused, or a style we can't fill: draw ghostty's hollow block.
    bool hollow = iFocus == 0
               || iCurrentCursorStyle == CURSORSTYLE_BLOCK_HOLLOW
               || iCurrentCursorStyle == CURSORSTYLE_LOCK;

    if (hollow) {
        float outer = sdfRect(fragCoord, rectCenter(cur), cur.zw * 0.5);
        // Band between the rect edge and an inset copy: the border.
        float ring  = max(outer, -(outer + HOLLOW_T));
        float cov   = 1.0 - smoothstep(0.0, AA, ring);
        if (cov <= 0.0) return;
        fragColor = mix(tex, vec4(iCurrentCursorColor.rgb, 1.0), cov);
        return;
    }

    vec4 prev = iPreviousCursor;
    // An all-zero previous cursor is the first frame after launch; don't
    // glide in from the window corner.
    if (dot(prev.zw, prev.zw) == 0.0) prev = cur;

    float t = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float e = ease(t);

    vec2 center   = mix(rectCenter(prev), rectCenter(cur), e);
    vec2 halfSize = mix(prev.zw, cur.zw, e) * 0.5;
    vec3 rgb      = mix(iPreviousCursorColor.rgb, iCurrentCursorColor.rgb, e);
    vec4 cursor   = vec4(rgb, 1.0);

    float coverage = 1.0 - smoothstep(0.0, AA, sdfRect(fragCoord, center, halfSize));
    if (coverage <= 0.0) return;

    // The cell's own background, from the median of its four corners. An alpha
    // test can't do this: a TUI cell painting a solid background is just as
    // opaque as a glyph. A single corner isn't enough either -- a tall or
    // underlined glyph can reach one, which would hide the character entirely.
    vec2  in2 = vec2(1.5, -1.5);
    vec3  cellBg = med4(
        texAt(cur.xy + in2),
        texAt(cur.xy + vec2(cur.z - in2.x, in2.y)),
        texAt(cur.xy + vec2(in2.x, -cur.w - in2.y)),
        texAt(cur.xy + vec2(cur.z - in2.x, -cur.w - in2.y)));
    float diff = distance(tex.rgb, cellBg);

    if (DEBUG_MASK) {
        fragColor = mix(tex, vec4(vec3(diff), 1.0), coverage);
        return;
    }

    // Pick the glyph treatment from cursor brightness so changing cursor-color
    // never needs a shader edit: darken the glyph under a light cursor, keep it
    // as-is under a dark one. Scaling rgb preserves hue, so colors survive.
    float luma  = dot(cursor.rgb, vec3(0.299, 0.587, 0.114));
    vec4  glyph = luma > 0.45 ? vec4(tex.rgb * GLYPH_DARKEN, 1.0) : tex;
    float inTarget = 1.0 - step(0.0, sdfRect(fragCoord, rectCenter(cur), cur.zw * 0.5));
    float text     = smoothstep(GLYPH_EDGE0, GLYPH_EDGE1, diff) * inTarget;
    vec4 cursorPixel = mix(cursor, glyph, text);

    fragColor = mix(tex, cursorPixel, coverage);
}

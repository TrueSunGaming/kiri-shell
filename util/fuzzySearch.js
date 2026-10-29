/**
 * @param {string} text 
 * @param {string} query 
 * @returns {[number, number[]]}
 */
function fuzzyScore(text, query) {
    if (!query) return [1, []];

    const target = text.toLowerCase();
    const search = query.toLowerCase();

    let targetIdx = 0;
    let searchIdx = 0;
    let score = 0;
    let consecutiveMatches = 0;
    const matchIndices = [];

    while (targetIdx < target.length && searchIdx < search.length) {
        if (target[targetIdx] == search[searchIdx]) {
            matchIndices.push(targetIdx);
            score += 10 + (consecutiveMatches * 5) - targetIdx;
            score += consecutiveMatches;
            consecutiveMatches++;
            searchIdx++;
        } else {
            consecutiveMatches = 0;
        }
        targetIdx++;
    }

    return searchIdx == search.length ? [score, matchIndices] : [-1, []];
}

/**
 * @template T
 * @param {T[]} items 
 * @param {string} query 
 * @param {(v: T) => string} preprocess 
 * @returns {{item: T, score: number, indices: number[], text: string}[]}
 */
function fuzzySearch(items, query, preprocess = v => v) {
    if (!query.trim()) return items.map((item) => ({
        item,
        score: 1,
        indices: [],
        text: preprocess(item)
    })).sort((a, b) => a.text.localeCompare(b.text));

    return items
        .map((item) => {
            const text = preprocess(item);
            const [score, indices] = fuzzyScore(preprocess(item), query);
            return {
                item,
                score,
                indices,
                text
            };
        })
        .filter((entry) => entry.score >= 0)
        .sort((a, b) => a.score == b.score ? a.text.localeCompare(b.text) : b.score - a.score);
}

/**
 * @param {number[]} indices 
 * @returns {[number, number][]}
 */
function getIndexRanges(indices) {
    if (indices.length == 0) return [];

    const res = [];
    let current = [];

    for (const idx of indices) {
        if (current.length == 0) {
            current = [idx, idx];
            continue;
        }

        if (idx != current[1] + 1) {
            res.push(current);
            current = [idx, idx];
            continue;
        }

        current[1] = idx;
    }

    res.push(current);

    return res;
}

/**
 * @param {{text: string, indices: number[]}}
 * @param {string} color
 * @returns {string}
 */
function toRichText({ text, indices }, color) {
    const ranges = getIndexRanges(indices);

    let split = text.split("");
    let offset = 0;

    for (const [start, end] of ranges) {
        split.splice(start + offset, 0, `<font color='${color}'>`);
        split.splice(end + offset + 2, 0, "</font>");
        offset += 2;
    }

    return split.join("");
}
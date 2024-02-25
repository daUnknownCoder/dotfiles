// ==UserScript==
// @name        fix array prototype pdfjs
// @include     qute://pdfjs/*
// @run-at      document-start
// ==/UserScript==

Object.defineProperty(Array.prototype, "at", {
    value: function(i) {
        if (i < 0)
            i += this.length
        return this[i]
    },
    enumerable: false
})

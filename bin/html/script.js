const superUI = document.getElementById('superUI');
const p1 = document.getElementById('p1');
const p2 = document.getElementById('p2');
const p3 = document.getElementById('p3');
const p4 = document.getElementById('p4');
const p5 = document.getElementById('p5');
const noPerms = document.getElementById('noPerms');

const elements = [p1, p2, p3, p4, p5];

document.addEventListener("DOMContentLoaded", function() {
    window.addEventListener("message", function(event) {
        let p = event.data.type

        if (event.data.isVisible) {
            superUI.classList.remove('hidden')

            for (let i = 0; i < p.length; i++) {
                if (p[i] == '1') {
                    elements[i].classList.remove('hidden');
                };
            };
        } else {
            superUI.classList.add('hidden');
        };
    });
});

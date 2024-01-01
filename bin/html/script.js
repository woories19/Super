document.addEventListener("DOMContentLoaded", function() {
    window.addEventListener("message", function(event) {
        var htmlBox = document.getElementById("htmlBox");
        var htmlBox2 = document.getElementById("htmlBox2");
        var htmlBox3 = document.getElementById("htmlBox3");
        var htmlBox4 = document.getElementById("htmlBox4");

        if (event.data.type === "toggleHtmlBox") {
            if (event.data.isVisible) {
                htmlBox.classList.remove("hidden");
            } else {
                htmlBox.classList.add("hidden");
            }
        } else if (event.data.type === "toggleHtmlBox2") {
            if (event.data.isVisible) {
                htmlBox2.classList.remove("hidden2");
            } else {
                htmlBox2.classList.add("hidden2");
            }
        } else if (event.data.type === "toggleHtmlBox3") {
            if (event.data.isVisible) {
                htmlBox3.classList.remove("hidden3");
            } else {
                htmlBox3.classList.add("hidden3");
            }
        } else if (event.data.type === "toggleHtmlBox4") {
            if (event.data.isVisible) {
                htmlBox4.classList.remove("hidden4");
            } else {
                htmlBox4.classList.add("hidden4");
            }
        } else if (event.data.type === "initHtmlBox") {
            // Additional initialization logic if needed
        }
    });
});

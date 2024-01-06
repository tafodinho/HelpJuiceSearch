// // Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
// import "@hotwired/turbo-rails"
// import "controllers"

document.addEventListener("DOMContentLoaded", function () {
  let realTimeTypingElement = null;
  let analyticsArea = document.getElementById("analytics-area");
  const inputBox = document.getElementById("search-box");
  inputBox.addEventListener("keyup", function (e) {
    if (e.key === " " || e.key === "Enter") {
      doneTyping();
    } else if (e.key === "Enter") {
      doneTyping();
      updateAnalytics();
      inputBox.value = "";
    }
  });

  inputBox.addEventListener("input", function (e) {
    console.log(e);
    if (!realTimeTypingElement) {
      realTimeTypingElement = document.createElement("p");
      const hr = document.createElement("hr");
      realTimeTypingElement.className =
        "typing mx-4 my-2 italic text-slate-600";
      analyticsArea.prepend(hr);
      analyticsArea.prepend(realTimeTypingElement);
    }
    realTimeTypingElement.textContent += e.data !== null ? e.data : "";
  });

  function doneTyping() {
    var query = document.getElementById("search-box").value.trim();
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/search?query=" + encodeURIComponent(query), true);

    xhr.onload = function () {
      console.log(xhr);
      if (xhr.status == 200) {
        console.log("Search recorded:", query);
      }
    };
    xhr.send();
  }

  function updateAnalytics() {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "/analytics", true);
    xhr.onload = function () {
      console.log(xhr);
      if (xhr.status == 200) {
        console.log("Search recorded:", xhr);
      }
    };
    xhr.send();
  }
});

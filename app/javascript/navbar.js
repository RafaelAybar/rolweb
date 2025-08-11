import { isMobile } from "isMobile";

document.addEventListener("DOMContentLoaded", () => {
  const subnavbar = document.querySelector(".subnavbar");
  const scrollIndicator = document.querySelector(".subnavbar-scroll_indicator");

  function updateScrollIndicator() {
    if (subnavbar.scrollWidth > subnavbar.clientWidth) {
      scrollIndicator.style.display = "block";
    } else {
      scrollIndicator.style.display = "none";
    }
  }


  function setupMobileSubmenus() {
    if (isMobile()) {
      const all_submenus = subnavbar.querySelectorAll(".submenu");
      const all_submenu_contents = subnavbar.querySelectorAll(".submenu-content");

      all_submenus.forEach(submenu => {
        const link = submenu.querySelector("a.nblink");

        if (link.classList.contains("nblink_notSubMenu")) return;

        let button = document.createElement("button");
        button.className = link.className;
        button.innerHTML = link.innerHTML;
        link.parentNode.replaceChild(button, link);

        const content = submenu.querySelector(".submenu-content");
        content.style.left = "0";

        button.addEventListener("click", (e) => {
          let currDisplay = content.style.display;
          all_submenu_contents.forEach(sc => sc.style.display = "none");
          if (currDisplay == "none") {
            content.style.display = "block";
          }
        });
      });
    }
  }


  // Initial setup
  updateScrollIndicator();
  setupMobileSubmenus();

  // Update on resize
  window.addEventListener("resize", updateScrollIndicator());
});

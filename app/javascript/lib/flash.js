document.addEventListener("turbo:load", () => {
  const alert = document.querySelector(".alert");
  if (!alert) return;

  setTimeout(() => {
    alert.classList.replace("opacity-100", "opacity-0");
  }, 5000);

  setTimeout(() => {
    alert.remove();
  }, 6000);
});
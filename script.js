const API_URL = "api/data.php";
const demoGallery = [
  { title: "Belajar bersama di SMP Mefeng", description: "Ruang kelas yang penuh cerita", image: "" },
  { title: "Kegiatan kreatif siswa", description: "Berani berkreasi", image: "" },
  { title: "Komunitas yang saling mendukung", description: "Tumbuh bersama", image: "" }
];

document.getElementById("current-year").textContent = new Date().getFullYear();

const menuToggle = document.querySelector(".menu-toggle");
const navMenu = document.getElementById("site-menu");
const messageCard = document.getElementById("messages");
const triggerFormButtons = document.querySelectorAll('[data-scroll-to="messages"]');
const closeFormButton = messageCard.querySelector(".modal-close");
let lastFocusedElement;

menuToggle.addEventListener("click", () => {
  const isOpen = menuToggle.getAttribute("aria-expanded") === "true";
  menuToggle.setAttribute("aria-expanded", String(!isOpen));
  navMenu.classList.toggle("is-open", !isOpen);
});
navMenu.querySelectorAll("a").forEach((link) => link.addEventListener("click", () => {
  menuToggle.setAttribute("aria-expanded", "false");
  navMenu.classList.remove("is-open");
}));

function showMessageForm() {
  lastFocusedElement = document.activeElement;
  messageCard.hidden = false;
  document.body.classList.add("modal-open");
  const firstInput = messageCard.querySelector("input, textarea");
  if (firstInput) firstInput.focus();
}

function hideMessageForm() {
  messageCard.hidden = true;
  document.body.classList.remove("modal-open");
  if (lastFocusedElement) lastFocusedElement.focus();
}

triggerFormButtons.forEach((button) => {
  button.addEventListener("click", () => {
    navMenu.classList.remove("is-open");
    menuToggle.setAttribute("aria-expanded", "false");
    showMessageForm();
  });
});
closeFormButton.addEventListener("click", hideMessageForm);
messageCard.addEventListener("click", (event) => {
  if (event.target === messageCard) hideMessageForm();
});
document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && !messageCard.hidden) hideMessageForm();
});

function renderGallery(items) {
  const grid = document.getElementById("gallery-grid");
  const escapeHtml = (value) => String(value).replace(/[&<>"']/g, (character) => ({
    "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#039;"
  }[character]));
  grid.innerHTML = items.map((item, index) => {
    const extraClass = index === 0 ? " gallery-card-large" : "";
    const placeholder = item.image
      ? `<img class="gallery-image" src="${escapeHtml(item.image)}" alt="${escapeHtml(item.title)}" loading="lazy">`
      : `<div class="gallery-placeholder placeholder-${index + 1}"><span>${escapeHtml(item.description)}</span></div>`;
    return `<article class="gallery-card${extraClass}">${placeholder}<p>${escapeHtml(item.title)}</p></article>`;
  }).join("");
}

function renderProfile(profile) {
  if (!profile) return;
  const profileFields = {
    "profile-description": profile.description,
    "profile-tagline": profile.tagline,
    "profile-email": profile.email,
    "profile-phone": profile.phone,
    "profile-address": profile.address
  };
  Object.entries(profileFields).forEach(([id, value]) => {
    const element = document.getElementById(id);
    if (element && value) element.textContent = value;
  });
  const emailLink = document.getElementById("profile-email-link");
  const phoneLink = document.getElementById("profile-phone-link");
  if (emailLink && profile.email) emailLink.href = `mailto:${profile.email}`;
  if (phoneLink && profile.phone) phoneLink.href = `tel:${profile.phone.replace(/[^\d+]/g, "")}`;
}

fetch(`${API_URL}?route=profile`)
  .then((response) => response.ok ? response.json() : Promise.reject(new Error("API tidak tersedia")))
  .then((data) => renderProfile(data.profile))
  .catch((error) => console.warn("Data profile tidak dapat dimuat:", error));

fetch(`${API_URL}?route=gallery`)
  .then((response) => response.ok ? response.json() : Promise.reject(new Error("API tidak tersedia")))
  .then((data) => Array.isArray(data.gallery) && data.gallery.length ? renderGallery(data.gallery) : renderGallery(demoGallery))
  .catch(() => renderGallery(demoGallery));

const form = document.getElementById("contact-form");
const status = document.getElementById("form-status");

function showAlert(icon, title, text) {
  if (window.Swal) {
    Swal.fire({ icon, title, text, confirmButtonColor: "#0d5c5a" });
    return;
  }
  window.alert(`${title}\n${text}`);
}

function validateForm() {
  const fields = {
    name: form.querySelector("#name"),
    email: form.querySelector("#email"),
    phone: form.querySelector("#phone"),
    address: form.querySelector("#address"),
    message: form.querySelector("#message")
  };

  const name = fields.name.value.trim();
  const email = fields.email.value.trim();
  const phone = fields.phone.value.trim();
  const address = fields.address.value.trim();
  const message = fields.message.value.trim();

  if (!/^[\p{L}\p{M}][\p{L}\p{M}\s.'-]{1,119}$/u.test(name)) {
    showAlert("error", "Nama tidak valid", "Nama lengkap minimal 2 karakter.");
    fields.name.focus();
    return false;
  }

  if (email.length > 190 || !/^[^\s@]+@[^\s@]+\.[^\s@]{2,}$/.test(email)) {
    showAlert("error", "Email tidak valid", "Masukkan alamat email yang benar.");
    fields.email.focus();
    return false;
  }

  if (!/^(?:\+62|62|0)8[0-9\s-]{7,11}$/.test(phone) || phone.replace(/[^\d]/g, "").length < 10) {
    showAlert("error", "Nomor telepon tidak valid", "Masukkan nomor telepon yang valid untuk Indonesia.");
    fields.phone.focus();
    return false;
  }

  if (address.length < 10 || address.length > 255 || /[\u0000-\u001f\u007f]/.test(address)) {
    showAlert("error", "Alamat terlalu pendek", "Alamat minimal 10 karakter.");
    fields.address.focus();
    return false;
  }

  if (message.length < 20 || message.length > 1000 || /[\u0000-\u0008\u000b\u000c\u000e-\u001f\u007f]/.test(message)) {
    showAlert("error", "Pesan terlalu singkat", "Pesan minimal 20 karakter agar jelas.");
    fields.message.focus();
    return false;
  }

  return true;
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  if (!validateForm()) {
    return;
  }

  const button = form.querySelector("button");
  button.disabled = true;
  status.className = "form-status";
  status.textContent = "Mengirim pesan...";

  try {
    const response = await fetch(`${API_URL}?route=messages`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(Object.fromEntries(new FormData(form).entries()))
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.message || "Pesan gagal dikirim.");

    showAlert("success", "Pesan terkirim", result.message);

    status.textContent = result.message;
    form.reset();
  } catch (error) {
    status.className = "form-status error";
    status.textContent = error.message || "Terjadi kesalahan saat mengirim pesan.";
    showAlert("error", "Gagal mengirim", error.message || "Pastikan API dan database sudah berjalan.");
  } finally {
    button.disabled = false;
  }
});

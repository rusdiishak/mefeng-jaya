const API_URL = "api/data.php";

// Mencegah aksi inspeksi yang umum tanpa mengganggu input formulir.
document.addEventListener("contextmenu", (event) => event.preventDefault());
document.addEventListener("dragstart", (event) => event.preventDefault());
document.addEventListener("selectstart", (event) => {
  if (!(event.target instanceof Element)
    || !event.target.closest("input, textarea, [contenteditable='true']")) {
    event.preventDefault();
  }
});

document.addEventListener("keydown", (event) => {
  const key = event.key.toLowerCase();
  const isDevToolsShortcut = event.key === "F12"
    || (event.ctrlKey && event.shiftKey && ["i", "j", "c"].includes(key))
    || (event.ctrlKey && key === "u");

  if (isDevToolsShortcut) {
    event.preventDefault();
    event.stopPropagation();
  }
});

const menuToggle = document.querySelector(".navbar-toggler");
const navMenu = document.getElementById("site-menu");
const messageCard = document.getElementById("messages");
const triggerFormButtons = document.querySelectorAll('[data-scroll-to="messages"]');
const closeFormButton = messageCard.querySelector(".modal-close");
let lastFocusedElement;

function closeNavigation() {
  if (window.bootstrap) {
    window.bootstrap.Collapse.getOrCreateInstance(navMenu).hide();
  }
}

navMenu.querySelectorAll("a").forEach((link) => link.addEventListener("click", closeNavigation));

function showMessageForm() {
  lastFocusedElement = document.activeElement;
  messageCard.hidden = false;
  document.body.classList.add("modal-open");
  closeNavigation();
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

function renderPage(page) {
  const { content, profile, contact, gallery } = page;
  Object.entries(content).forEach(([key, value]) => {
    document.querySelectorAll(`[data-content="${key}"]`).forEach((element) => {
      element.innerHTML = value;
    });
  });
  const proof = String(content.hero_proof || "").split("|");
  document.querySelector('[data-content="hero_proof_strong"]').textContent = proof[0] || "";
  document.querySelector('[data-content="hero_proof_text"]').textContent = proof[1] || "";
  ["stat_1", "stat_2", "stat_3"].forEach((key) => {
    const [value, text] = String(content[key] || "").split("|");
    document.querySelector(`[data-stat="${key}_value"]`).textContent = value || "";
    document.querySelector(`[data-stat="${key}_text"]`).textContent = text || "";
  });
  document.getElementById("meta-description").content = content.meta_description || "";
  document.getElementById("page-title").textContent = content.page_title || "";
  document.getElementById("footer-text").textContent = contact.footer_text || "";
  document.getElementById("skip-link").textContent = content.skip_link || "";
  document.querySelector(".stats").setAttribute("aria-label", content.stats_label || "");
  document.querySelector(".site-header nav").setAttribute("aria-label", content.nav_home || "");
  document.querySelector(".brand").setAttribute("aria-label", content.brand_name || "");
  document.querySelector(".hero-art").setAttribute("aria-label", content.hero_description || "");
  const profileImage = document.getElementById("profile-image");
  document.querySelector(".social-links").setAttribute("aria-label", content.brand_name || "");
  document.querySelector(".map-card").setAttribute("aria-label", content.map_name || "");
  document.querySelector(".map-card iframe").title = content.map_name || "";
  document.querySelector(".modal-close").setAttribute("aria-label", content.nav_message || "");
  document.querySelector(".navbar-toggler").setAttribute("aria-label", content.menu_open || "");

  if (profile) {
    if (profileImage) {
      profileImage.alt = `Foto ${profile.name || "pendiri Yayasan Mefeng Jaya"}`;
      if (profile.photo_url) {
        profileImage.src = profile.photo_url;
        profileImage.hidden = false;
        document.querySelector(".hero-art").classList.add("has-profile-image");
      } else {
        profileImage.hidden = true;
        document.querySelector(".hero-art").classList.remove("has-profile-image");
      }
    }
    document.getElementById("profile-description").textContent = profile.description || content.hero_description || "";
    document.getElementById("profile-tagline").textContent = profile.tagline || content.contact_intro || "";
    document.getElementById("profile-email").textContent = profile.email || contact.email || "";
    document.getElementById("profile-phone").textContent = profile.phone || contact.phone || "";
    document.getElementById("profile-address").textContent = profile.address || contact.address || "";
    document.getElementById("profile-email-link").href = `mailto:${profile.email || contact.email || ""}`;
    document.getElementById("profile-phone-link").href = `tel:${(profile.phone || contact.phone || "").replace(/[^\d+]/g, "")}`;
  }
  if (contact) {
    document.getElementById("instagram-link").href = contact.instagram_url || "";
    document.getElementById("facebook-link").href = contact.facebook_url || "";
    document.getElementById("youtube-link").href = contact.youtube_url || "";
    document.getElementById("instagram-link").setAttribute("aria-label", content.social_instagram_label || "");
    document.getElementById("facebook-link").setAttribute("aria-label", content.social_facebook_label || "");
    document.getElementById("youtube-link").setAttribute("aria-label", content.social_youtube_label || "");
    document.getElementById("map-frame").src = contact.map_url || "";
  }
  renderGallery(gallery);
}

fetch(`${API_URL}?route=page`)
  .then((response) => response.ok ? response.json() : Promise.reject(new Error("Data halaman tidak tersedia")))
  .then(renderPage)
  .catch((error) => console.warn("Data halaman tidak dapat dimuat:", error));

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

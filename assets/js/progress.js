const previewImage = (file, imageContainer) => {
  var fileReader = new FileReader();
  fileReader.readAsDataURL(file);
  fileReader.onload = event => {
    imageContainer.style.backgroundImage = `url('${event.target.result}')`;
  };
};

const setupProgressScreen = (selector, progressText) => {
  let section = document.querySelector(selector);
  if (!section) {
    return;
  }
  let form = section.querySelector("form");
  let fileInput = form.querySelector("input[type='file']");
  let submitButton = form.querySelector("input[type='submit']");

  const changeText = () => {
    let header = section.querySelector("header.dialog h2");
    header.innerText = progressText;
  };
  const hideForm = () => {
    let actions = section.querySelector(".actions");
    actions.classList.add("hide");
  };
  const showProgressImage = () => {
    let progress = section.querySelector(".progress");
    let imageContainer = progress.querySelector(".image");
    previewImage(fileInput.files[0], imageContainer);
    progress.classList.remove("hide");
  };

  submitButton.addEventListener("click", event => {
    if (form.checkValidity()) {
      changeText();
      hideForm();
      showProgressImage();
    } else {
      event.preventDefault();
    }
  });
};

const setupProgressScreens = () => {
  setupProgressScreen(".js-login", "We're looking you up from your face...");
  setupProgressScreen(".js-register", "We're registering your face now...");
};

export default setupProgressScreens;

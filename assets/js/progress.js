const previewImage = (file, imageContainer) => {
  var fileReader = new FileReader();
  fileReader.readAsDataURL(file);
  fileReader.onload = event => {
    imageContainer.style.backgroundImage = `url('${event.target.result}')`;
  };
};

const setupProgressScreen = (
  selector,
  { progressText, errorText, errorPath }
) => {
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
  const submitForm = () => {
    fetch(form.action, {
      body: new FormData(form),
      method: "post"
    })
      .then(response => {
        console.debug(response);
        window.location = response.url;
      })
      .catch(error => {
        const encodedErrorMessage = encodeURIComponent(errorText);
        window.location = `/${errorPath}?error=${encodedErrorMessage}`;
      });
  };

  submitButton.addEventListener("click", event => {
    event.preventDefault();

    if (form.checkValidity()) {
      changeText();
      hideForm();
      showProgressImage();
      submitForm();
    }
  });
};

const setupProgressScreens = () => {
  setupProgressScreen(".js-login", {
    progressText: "We're looking you up from your face...",
    errorText: "Something went wrong logging in :(",
    errorPath: "login"
  });
  setupProgressScreen(".js-register", {
    progressText: "We're registering your face now...",
    errorText: "Something went wrong :(",
    errorPath: "register"
  });
};

export default setupProgressScreens;

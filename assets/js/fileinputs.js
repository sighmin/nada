const getFile = target => {
  if (target.files.length === 0) {
    return false;
  } else {
    return target.files[0];
  }
};

const updateLabelText = (target, file) => {
  let label = target.previousElementSibling;

  if (file) {
    label.innerText = file.name;
  } else {
    label.innerText = "Take a selfie / Choose a photo";
  }
};

const setupFileInputs = () => {
  let fileInputs = document.querySelectorAll("input[type='file']");
  fileInputs.forEach(fileInput => {
    fileInput.addEventListener("change", ({ target }) => {
      let file = getFile(target);
      updateLabelText(target, file);
      if (!file) {
        return;
      }
      //compressImage(target, file);
    });
  });
};

export default setupFileInputs;

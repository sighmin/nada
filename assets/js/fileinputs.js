const setupFileInputs = () => {
  let fileInputs = document.querySelectorAll("input[type='file']");
  fileInputs.forEach(fileInput => {
    fileInput.addEventListener("change", ({ target }) => {
      let fileName = target.files[0].name;
      let label = target.previousElementSibling;
      label.innerText = fileName;
    });
  });
};

export default setupFileInputs;

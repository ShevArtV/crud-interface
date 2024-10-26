const project = {
  imaskScriptPath: 'assets/js/vendor/imask.js',

  insertData: (submitter) => {
    const data = JSON.parse(submitter.dataset.insert);
    const modal = document.querySelector(submitter.dataset.bsTarget);
    project.setFieldsValue(data, modal);
  },

  setFieldsValue: (data, modal) => {
    for (let key in data) {
      const field = modal.querySelector(`[name="${key}"]`);
      if (field) {
        field.value = data[key];
      }
    }
  },

  updatePagination: () => {
    const pagiantion = document.querySelector('[data-pn-pagination]');
    if (pagiantion && typeof SendIt !== 'undefined') {
      const paginationItem = SendIt.PaginationFactory.instances.get(pagiantion);
      paginationItem.goto(paginationItem.pageInput.value);
    }
  },

  loadScript: (path, callback, cssPath) => {
    if (document.querySelector('script[src="' + path + '"]')) {
      callback(path, "ok");
      return;
    }
    let done = false,
      scr = document.createElement('script');

    scr.onload = handleLoad;
    scr.onreadystatechange = handleReadyStateChange;
    scr.onerror = handleError;
    scr.src = path;
    document.body.appendChild(scr);

    function handleLoad() {
      if (!done) {
        if (cssPath) {
          let css = document.createElement('link');
          css.rel = 'stylesheet';
          css.href = cssPath;
          document.head.prepend(css);
        }
        done = true;
        callback(path, "ok");
      }
    }

    function handleReadyStateChange() {
      let state;

      if (!done) {
        state = scr.readyState;
        if (state === "complete") {
          handleLoad();
        }
      }
    }

    function handleError() {
      if (!done) {
        done = true;
        callback(path, "error");
      }
    }
  },

  setMasks: () => {
    const phoneInputs = document.querySelectorAll('[name="phone"]');
    if (phoneInputs) {
      phoneInputs.forEach(el => {
        IMask(el, {mask: '+{7}({9}00)000-00-00'})
      })
    }
  }

}

document.addEventListener('DOMContentLoaded', e => {
  project.loadScript(project.imaskScriptPath, () => {
    project.setMasks();
  });
})

document.addEventListener('si:send:finish', (e) => {
  const {headers, result} = e.detail;
  if (result.success) {

    if (['manage_user','remove_user'].includes(headers['X-SIPRESET'])) {
      project.updatePagination();
    }

    if (['find_user'].includes(headers['X-SIPRESET'])) {
      const popup = document.querySelector(result.data.popup);
      const offcanvas = bootstrap.Offcanvas.getOrCreateInstance(popup);
      popup && project.setFieldsValue(result.data, popup);
      offcanvas && offcanvas.show();
      project.setInviteAttr(result.data)
    }
  }
})

document.addEventListener('click', e => {
  e.target.closest('[data-insert]') && project.insertData(e.target.closest('[data-insert]'));
})

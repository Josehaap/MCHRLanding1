window.getBrowserLanguage = function () {
    return navigator.language || navigator.userLanguage;
};

window.getPreferredLanguages = function () {
    return navigator.languages;
};
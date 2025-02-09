window.onload = () => {

    function toggleFullScreen() {
        if (!document.fullscreenElement) {
            document.documentElement.requestFullscreen();
        } else {
            document.exitFullscreen();
        }
    }

    function enterFullScreen() {
        document.documentElement.requestFullscreen();
    }

    function exitFullScreen() {
        document.exitFullscreen();
    }

    window._toggleFullScreen = toggleFullScreen
    window._enterFullScreen = enterFullScreen
    window._exitFullScreen = exitFullScreen
}
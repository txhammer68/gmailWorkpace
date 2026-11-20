import QtQuick
import QtWebEngine
import org.kde.kirigami as Kirigami

WebEngineView {
    id: webView
    required property string viewUrl
    required property bool forceDark

    property bool restoringZoom: false

    function getHost(targetUrl) {
        let str = String(targetUrl || "")
        if (str === "" || str === "about:blank") return ""
            try {
                return new URL(str).hostname
            } catch (e) {
                return ""
            }
    }

    function applySavedZoom() {
        let host = getHost(webView.url)
        if (host === "") return

            restoringZoom = true
            if (root.zoomMap[host] !== undefined) {
                webView.zoomFactor = root.zoomMap[host]
            } else {
                webView.zoomFactor = 1.0
            }
            restoringZoom = false
    }

    anchors.fill: parent
    focus: true
    antialiasing: true
    backgroundColor: Kirigami.Theme.backgroundColor
    profile: webProfile
    url: viewUrl

    settings {
        javascriptCanAccessClipboard: true
        forceDarkMode: forceDark
            playbackRequiresUserGesture: true
            pdfViewerEnabled: selectedView === "viewGmail" || selectedView === "drive"
            scrollAnimatorEnabled: true
    }

    onNewWindowRequested: function(request) {
        if (request.userInitiated) {
            request.action = WebEngineView.IgnoreRequest
            Qt.openUrlExternally(request.requestedUrl)
        }
    }

    onFeaturePermissionRequested: {
        grantFeaturePermission(securityOrigin, feature, true)
    }

    // Re-apply saved zoom whenever the deferred viewUrl is assigned or finishes loading
    onUrlChanged: applySavedZoom()
    onLoadingChanged: function(loadRequest) {
        if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
            applySavedZoom()
        }
    }

    onZoomFactorChanged: {
        // Ignore zoom changes triggered by applySavedZoom() itself
        if (restoringZoom) return

            let host = getHost(webView.url)
            if (host !== "") {
                root.zoomMap[host] = webView.zoomFactor
                appSettings.serializedZoomMap = JSON.stringify(root.zoomMap)
                appSettings.sync()
            }
    }
}

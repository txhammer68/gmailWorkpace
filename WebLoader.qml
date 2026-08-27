import QtQuick
import QtWebEngine
import org.kde.kirigami as Kirigami

WebEngineView {
    id: webView
    required property string viewUrl
    required property bool forceDark

    function getHost(url) {
        var urlObj = new URL(url);
        return urlObj.hostname;
    }

    anchors.fill: parent
    focus: visible
    antialiasing: true
    backgroundColor: Kirigami.Theme.backgroundColor
    profile: webProfile
    zoomFactor:root.zoomMap[host] !== undefined ? root.zoomMap[host]:1.0
    url:viewUrl

    settings {
        javascriptCanAccessClipboard: true
        forceDarkMode: forceDark
        playbackRequiresUserGesture: true
        pdfViewerEnabled: selectedView === "viewGmail" || selectedView === "viewDrive"
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

    Component.onCompleted: {

        var host = getHost(webView.url);

        // If we have a saved zoom for this domain, apply it
        if (root.zoomMap[host] !== undefined) {
            webView.zoomFactor = root.zoomMap[host];
        } else {
            webView.zoomFactor = 1.0; // Default
        }
    }

    onZoomFactorChanged: {
        var host = getHost(webView.url);
        if (host !== "") {
            // Update shared dictionary dynamically when user zooms
            var currentMap = root.zoomMap;
            currentMap[host] = webView.zoomFactor;
            root.zoomMap = currentMap; // Trigger QML binding updates
        }
    }
}

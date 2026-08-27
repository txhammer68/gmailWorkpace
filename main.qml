import QtQuick
import QtQuick.Controls
import QtWebEngine
import org.kde.kirigami as Kirigami
import QtCore

// txhammer 11/2025
// kde plasma qt 6 qml app
// g-mail suite workspace app using Qt.WebEngineView
// load multiple webviews to create an Google Workspaces like app
// included google apps [gmail,gcal,contacts,chat,voip,news,maps,drive,search]
// keep google out your normal web browser
// NOTE: Google account info/password is saved encrypted in: $HOME/.local/share/QtProject/Qml Runtime/QtWebEngine/gmail/

ApplicationWindow {
    id:root
    visible:true
    visibility:"Maximized"
    title:"Google Workspaces"
    color:Kirigami.Theme.activeBackgroundColor
    onClosing: Qt.destroy();

    property bool darkMode: Application.styleHints.colorScheme === Qt.ColorScheme.Dark
    property string selectedView:"viewGmail"

    property var items: [
        { id: "gmail", icon: "gmail.png", label: "Inbox", view: "viewGmail",url:"https://mail.google.com/mail/u/0/#inbox"},
        { id: "gcal", icon: "gcal.png", label: "Calendar", view: "viewCal",url:"https://calendar.google.com/calendar/u/0/r"},
        { id: "contacts", icon: "contacts.png", label: "Contacts", view: "viewContacts",url:"https://contacts.google.com/?hl=en#contacts" },
        { id: "chat", icon: "chat.png", label: "Chat", view: "chat",url:"https://mail.google.com/chat/u/0/#chat/home"},
        { id: "voice", icon: "voice.png", label: "VOIP", view: "voip",url:"https://voice.google.com/u/0/calls"},
        { id: "maps", icon: "maps.png", label: "Maps", view: "maps",url:"https://www.google.com/maps/"},
        { id: "news", icon: "news.png", label: "News", view: "news",url:"https://news.google.com/topstories/"},
        { id: "drive", icon: "drive.png", label: "G-Drive", view: "drive",url:"https://drive.google.com/drive/"},
        { id: "search", icon: "search.png", label: "Search", view: "search",url:"https://www.google.com/"}
    ]

    Shortcut {
        sequence: "Ctrl+Q"
        onActivated: root.close()
    }

    Component.onCompleted: {
        Qt.application.name = "GoogleWorkSpaces"
        Qt.application.organization = "StandaloneApps"
        Qt.application.domain = "local"
        // Restore saved mapping on startup
        try {
            zoomMap = JSON.parse(appSettings.serializedZoomMap);
        } catch(e) {
            zoomMap = {};
        }
    }

    Component.onDestruction: {
       appSettings.serializedZoomMap = JSON.stringify(zoomMap);
    }

    Settings {
        id: appSettings
        category: "WebBrowser"
        location: StandardPaths.writableLocation(StandardPaths.ConfigLocation)+"/gmail"
        // Store the dictionary as a serialized JSON string
        property string serializedZoomMap: "{}"
    }

    property var zoomMap: ({})

    WebEngineProfile {
        id:webProfile
        offTheRecord : false
        storageName :"gmail"
        persistentPermissionsPolicy:WebEngineProfile.StoreOnDisk
        persistentCookiesPolicy : WebEngineProfile.AllowPersistentCookies
        httpCacheType:WebEngineProfile.DiskHttpCache
    }

    Item {
        id:viewGmail
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[0].view
        WebLoader {viewUrl:items[0].url;forceDark:false} // dark mode not needed with gmail inbox...
    }

    Item {
        id:viewCal
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[1].view
        WebLoader {viewUrl:items[1].url;forceDark:darkMode}
    }

    Item {
        id:viewContacts
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[2].view
        WebLoader {viewUrl:items[2].url;forceDark:darkMode}
    }

    Item {
        id:viewChat
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[3].view
        WebLoader {viewUrl:items[3].url;forceDark:darkMode}
    }

    Item {
        id:viewVOIP
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[4].view
        WebLoader {viewUrl:items[4].url;forceDark:darkMode}
    }

    Item {
        id:viewMaps
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[5].view
        WebLoader {viewUrl:items[5].url;forceDark:darkMode}
    }

    Item {
        id:viewNews
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[6].view
        WebLoader {viewUrl:items[6].url;forceDark:darkMode}
    }

    Item {
        id:viewDrive
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[7].view
        WebLoader {viewUrl:items[7].url;forceDark:darkMode}
    }

    Item {
        id:viewSearch
        anchors.left:navbar.right
        anchors.top:navbar.top
        anchors.leftMargin:10
        height:root.height
        width:root.width-navbar.width-10
        visible:selectedView == items[8].view
        WebLoader {viewUrl:items[8].url;forceDark:darkMode}
    }

    Column {
        id: navbar
        spacing: 20
        width: 60
        leftPadding: 10
        topPadding: 10

        Repeater {
            model: items
            delegate: Column {
                spacing: 15
                width:55
                height:64
                leftPadding:5
                topPadding:5
                Image {
                    width: 36
                    height: 36
                    source: "./icons/" + modelData.icon
                    antialiasing: true
                    opacity:selectedView == modelData.view  ||  mouseArea.containsMouse ? 1:.5
                    Text {
                        anchors.top:parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: modelData.label
                        color: Kirigami.Theme.textColor
                        font.pointSize: 10
                        antialiasing: true
                    }

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: selectedView = modelData.view
                    }
                }
            }
        }

        // Settings button (separate since it has different behavior)
        Item { height: 50; width: 1 } // spacer

        Image {
            id:settings
            width: 36
            height: 36
            source: "./icons/settings.png"
            antialiasing: true
            opacity:settingsMouseArea.containsMouse ? 1:.5

            MouseArea {
                id: settingsMouseArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: settingsPopup.open()
            }
        }
    }

    Popup {
        id: settingsPopup
        x: settings.x+48
        y: settings.y+5
        width: 120
        height: 48
        padding: 10
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.Popup.CloseOnPressOutside

        contentItem:
        Text {
            text: "Clear Cache"
            color:Kirigami.Theme.textColor
            topPadding:5
            leftPadding:10

            MouseArea {
                id: mouseAreaPopup
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onEntered:parent.color=Kirigami.Theme.linkColor
                onExited:parent.color=Kirigami.Theme.textColor
                onClicked:{
                    webProfile.clearHttpCache()
                    settingsPopup.close()
                }
            }
        }
    }
}

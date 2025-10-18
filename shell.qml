import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time

  Variants {
    model: Quickshell.screens

    PanelWindow {
      color: "green"
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      implicitHeight: 48

      Text {
        anchors.centerIn: parent
        text: root.time
      }

      Loader {
        source: "modules/bar/bar.qml"
      }
    }
  }

  Process {
    id: dateProc
    command: ["date", "+%H:%M:%S"]
    running: true

    stdout: StdioCollector {
      onStreamFinished: root.time = this.text
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: dateProc.running = true
  }
}
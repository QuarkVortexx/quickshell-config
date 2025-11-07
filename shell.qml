import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

import "modules/bar"

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        Bar {
            modelData: modelData
        }
        
    }
}

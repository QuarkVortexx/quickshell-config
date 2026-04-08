import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire 

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes

import qs.util

PopupWindow {
    id: calendarPanel

    visible: StateStore.calendarOpen
    color: "transparent"

    implicitWidth: calendarGrid.width + calendarContent.anchors.margins * 2
    implicitHeight: calendarContent.implicitHeight + calendarContent.anchors.margins * 2

    property date today: new Date()
    property int viewMonth: today.getMonth()
    property int viewYear: today.getFullYear()
    property int weekCount: weeksInMonth(viewYear, viewMonth)

    function daysInMonth(y, m) {
        return new Date(y, m + 1, 0).getDate()
    }

    // Calculate how many weeks are needed for the current month view
    function weeksInMonth(y, m) {
        let firstDay = firstDayOfMonth(y, m)
        let days = daysInMonth(y, m)
        let total = firstDay + days
        return Math.ceil(total / 7)
    }

    function firstDayOfMonth(y, m) {
        let d = new Date(y, m, 1).getDay()
        return (d === 0 ? 6 : d - 1) // make Monday = 0
    }

    function weekNumber(date) {
        let d = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
        let dayNum = d.getUTCDay() || 7
        d.setUTCDate(d.getUTCDate() + 4 - dayNum)
        let yearStart = new Date(Date.UTC(d.getUTCFullYear(),0,1))
        return Math.ceil((((d - yearStart) / 86400000) + 1)/7)
    }

    Rectangle {
        id: calendarRoot
        anchors.fill: parent
        color: Colors.md3.surface
        border.color: Qt.lighter(Colors.md3.surface, 2.0)

        Column {
            id: calendarContent
            anchors.fill: parent
            anchors.margins: 16
            spacing: 8

            Text {
                text: {
                    let d = today
                    return Qt.formatDate(d, "dddd, dd. MMMM yyyy")
                }
                color: Colors.md3.on_surface
                font.bold: true
                font.weight: Font.DemiBold
                font.pixelSize: 20

                MouseArea {
                    anchors.fill: parent
                    enabled: viewMonth !== today.getMonth() || viewYear !== today.getFullYear()
                    cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                    onClicked: {
                        viewMonth = today.getMonth();
                        viewYear = today.getFullYear();
                    }
                    hoverEnabled: true
                    onEntered: parent.opacity = 0.85
                    onExited: parent.opacity = 1.0
                }
            }

            RowLayout {
                spacing: 0
                width: parent.width

                Text {
                    text: Qt.formatDate(new Date(viewYear, viewMonth), "MMMM yyyy")
                    color: Colors.md3.on_surface
                    font.pixelSize: 18
                    font.weight: Font.Light
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                }

                RowLayout {
                    spacing: 8
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

                    Text {
                        text: ""
                        font.pixelSize: 28
                        color: Colors.md3.primary
                        Layout.alignment: Qt.AlignVCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                viewMonth--
                                if (viewMonth < 0) {
                                    viewMonth = 11
                                    viewYear--
                                }
                            }
                        }
                    }
                    Text {
                        text: ""
                        font.pixelSize: 28
                        color: Colors.md3.primary
                        Layout.alignment: Qt.AlignVCenter
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                viewMonth++
                                if (viewMonth > 11) {
                                    viewMonth = 0
                                    viewYear++
                                }
                            }
                        }
                    }
                }
            }

            Row {
                spacing: 6
                Repeater {
                    model: ["#", "Mon","Tue","Wed","Thu","Fri","Sat","Sun"]
                    delegate: Text {
                        text: modelData
                        width: 30
                        horizontalAlignment: Text.AlignHCenter
                        color: modelData === "#" ? Colors.md3.primary : Qt.lighter(Colors.md3.on_surface, 1.5)
                    }
                }
            }

            // 🔢 Calendar grid with week numbers
            Column {
                id: calendarGrid
                spacing: 6

                Repeater {
                    model: weekCount
                    delegate: Row {
                        spacing: 6
                        property int weekIndex: index

                        // Week number cell
                        Rectangle {
                            width: 30
                            height: 30
                            color: "transparent"
                            Text {
                                anchors.centerIn: parent
                                text: {
                                    // Calculate the date for the Monday of this week
                                    let offset = firstDayOfMonth(viewYear, viewMonth)
                                    let day = weekIndex * 7 - offset + 1
                                    let month = viewMonth
                                    let year = viewYear
                                    let prevMonth = month === 0 ? 11 : month - 1
                                    let prevYear = month === 0 ? year - 1 : year
                                    let prevDim = daysInMonth(prevYear, prevMonth)
                                    let displayDay = day < 1 ? (prevDim + day) : (day > daysInMonth(year, month) ? (day - daysInMonth(year, month)) : day)
                                    let displayMonth = day < 1 ? prevMonth : (day > daysInMonth(year, month) ? (month === 11 ? 0 : month + 1) : month)
                                    let displayYear = day < 1 ? prevYear : (day > daysInMonth(year, month) ? (month === 11 ? year + 1 : year) : year)
                                    let date = new Date(displayYear, displayMonth, displayDay)
                                    return weekNumber(date)
                                }
                                color: Qt.lighter(Colors.md3.primary, 1.2)
                                font.pixelSize: 13
                            }
                        }

                        // 7 days in the week
                        Repeater {
                            model: 7
                            delegate: Rectangle {
                                width: 30
                                height: 30

                                property int indexInWeek: index
                                property int offset: firstDayOfMonth(viewYear, viewMonth)
                                property int dim: daysInMonth(viewYear, viewMonth)
                                property int prevMonth: viewMonth === 0 ? 11 : viewMonth - 1
                                property int prevYear: viewMonth === 0 ? viewYear - 1 : viewYear
                                property int prevDim: daysInMonth(prevYear, prevMonth)
                                property int globalIndex: weekIndex * 7 + indexInWeek
                                property int day: globalIndex - offset + 1

                                // Determine if this cell is prev, current, or next month
                                property bool isPrevMonth: day < 1
                                property bool isNextMonth: day > dim
                                property bool isCurrentMonth: !isPrevMonth && !isNextMonth

                                property int displayDay: isPrevMonth ? (prevDim + day) : (isNextMonth ? (day - dim) : day)
                                property int displayMonth: isPrevMonth ? prevMonth : (isNextMonth ? (viewMonth === 11 ? 0 : viewMonth + 1) : viewMonth)
                                property int displayYear: isPrevMonth ? prevYear : (isNextMonth ? (viewMonth === 11 ? viewYear + 1 : viewYear) : viewYear)

                                color: {
                                    if (isCurrentMonth) {
                                        if (displayDay === today.getDate()
                                                && viewMonth === today.getMonth()
                                                && viewYear === today.getFullYear())
                                            return Colors.md3.primary
                                        return "transparent"
                                    }
                                    return Qt.lighter(Colors.md3.surface, 1.5)
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: displayDay
                                    color: isCurrentMonth ? (parent.color == Colors.md3.primary ? Colors.md3.on_primary : Colors.md3.on_surface) : Colors.md3.on_surface
                                    opacity: isCurrentMonth ? 1.0 : 0.6
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: StateStore
        function onCalendarOpenChanged() {
            calendarPanelFocusGrab.active = StateStore.calendarOpen;
        }
    }

    HyprlandFocusGrab {
        id: calendarPanelFocusGrab
        windows: [calendarPanel]
        active: false
        onCleared: () => {
            StateStore.calendarOpen = false;
        }
    }
}

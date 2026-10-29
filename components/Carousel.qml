import QtQuick
import QtQuick.Layouts
import qs.data

Item {
    id: root

    clip: true

    property var model
    property Component delegate
    property string fallbackText: ""
    property int currentIndex: 0
    property alias layout: rowLayout

    readonly property int itemCount: repeater.count

    property bool repeaterUpdate: false
    readonly property Item currentItem: {
        void repeaterUpdate;
        return repeater.itemAt(currentIndex);
    }

    onItemCountChanged: fixCurrentIndex()

    implicitWidth: currentItem?.implicitWidth ?? 1
    implicitHeight: currentItem?.implicitHeight ?? 1

    function clampIndex(index: int): int {
        if (itemCount == 0) return 0;
        if (index < 0) return itemCount + (index + 1) % itemCount - 1;
        if (index >= itemCount) return index % itemCount;
        return index;
    }

    function setIndex(index: int): void {
        currentIndex = clampIndex(index);
    }

    function fixCurrentIndex(): void {
        setIndex(currentIndex);
    }

    function previous(amount = 1): void {
        setIndex(currentIndex - amount);
    }

    function next(amount = 1): void {
        setIndex(currentIndex + amount);
    }

    property real scrollOffset: -currentItem?.x ?? 0

    Behavior on scrollOffset {
        Spring {}
    }

    RowLayout {
        id: rowLayout

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: root.scrollOffset

        spacing: Sizing.sizeM

        Repeater {
            id: repeater
            model: root.model
            delegate: root.delegate

            onItemAdded: root.repeaterUpdateChanged()
            onItemRemoved: root.repeaterUpdateChanged()
        }
    }

    RowLayout {
        anchors.top: parent.top
        anchors.right: parent.right

        AccentPill {
            tappable: root.itemCount > 1
            onTapped: root.previous()

            MaterialIcon {
                iconName: "keyboard_arrow_left"
            }
        }

        AccentPill {
            tappable: root.itemCount > 1
            onTapped: root.next()

            MaterialIcon {
                iconName: "keyboard_arrow_right"
            }
        }
    }

    StyleText {
        id: fallback

        anchors.centerIn: parent
        visible: root.itemCount == 0 && root.fallbackText != ""

        text: root.fallbackText
        font.pixelSize: Sizing.sizeL
        color: Colors.disabledText
        italic: true
    }
}

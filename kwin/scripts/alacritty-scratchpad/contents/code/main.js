/*
# vim:tabstop=4:shiftwidth=4:noexpandtab
*/

function isAlacritty(client) {
    return client && !client.deleted && client.normalWindow && client.resourceName.toString() === "alacritty";
}

function findAlacritty() {
    let clients = workspace.windowList();
    print('WORKSPACE WIDTH');
    print(workspace.workspaceWidth);
    print('WORKSPACE HEIGHT');
    print(workspace.workspaceHeight);
    return clients.find(client => isAlacritty(client)) || null;
}

function isVisible(client) {
    return !client.minimized;
}

function isActive(client) {
    return client === workspace.activeWindow;
}

function activate(client) {
    workspace.activeWindow = client;
}

function setupClient(client) {
    print("setupClient");
    client.activeChanged.connect(function() {
		if (!client.active) {
			hide(client);
		}
    });

    client.onAllDesktops = true;
    client.skipTaskbar = true;
    client.skipSwitcher = true;
    client.skipPager = true;
    client.keepAbove = true;
    // client.setMaximize(true, true);
    client.fullScreen = false;
    printClient(client);
}

function printClient(client) {
    print("resourceName=" + client.resourceName.toString() +
        ";normalWindow=" + client.normalWindow +
        ";onAllDesktops=" + client.onAllDesktops +
        ";skipTaskbar=" + client.skipTaskbar +
        ";skipSwitcher=" + client.skipSwitcher +
        ";skipPager=" + client.skipPager +
        ";keepAbove=" + client.keepAbove +
        ";fullScreen=" + client.fullScreen +
        "");
}

const maxAspect = 1.6;
const scaleFactor = 0.8;


function show(client) {
    //Object.keys(client).forEach((prop)=> print(prop));
    client.minimized = false;
    client.fullScreen = false;
    client.keepAbove = false;
    client.noBorder = true;

    let wsWidth = workspace.workspaceWidth;
    let wsHeight = workspace.workspaceHeight;
    if ((wsWidth / wsHeight) > maxAspect) {
        wsHeight = Math.min(wsWidth, wsHeight);
        wsWidth = wsHeight * maxAspect;
    }

    let width = wsWidth * scaleFactor;
    let height = wsHeight * scaleFactor;
    let x = (workspace.workspaceWidth - width) / 2;
    let y = (workspace.workspaceHeight - height) / 2;
    client.frameGeometry = {
        x: x,
        y: y,
        width: width,
        height: height
    };
}

function hide(client) {
    client.minimized = true;
    client.fullScreen = false;
    client.keepAbove = false;
}

function toggleAlacritty() {
    let alacritty = findAlacritty();
    if ( alacritty ) {
        if ( isVisible(alacritty) ) {
            if ( isActive(alacritty) ) {
                hide(alacritty);
            } else {
                activate(alacritty);
            }
        } else {
            show(alacritty);
            activate(alacritty);
        }
    }
}

function setupAlacritty(client) {
    if ( isAlacritty(client) ) {
        setupClient(client);
        printClient(client);
    }
}

function init() {
    let alacritty = findAlacritty();
    if ( alacritty ) {
        setupClient(alacritty);
    }

    workspace.windowAdded.connect(setupAlacritty);
    registerShortcut("Alacritty Toggle", "Toggle Alacritty open/closed.", "Meta+Enter", toggleAlacritty);
}

init();


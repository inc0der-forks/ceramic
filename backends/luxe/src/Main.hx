package;

import ceramic.App;

class Main extends luxe.Game {

    override function config(config:luxe.GameConfig) {

        var app = @:privateAccess new App();

        // Configure luxe
        config.render.antialiasing = app.settings.antialiasing != null && app.settings.antialiasing ? 4 : 0;
        config.window.borderless = false;
        config.window.width = cast app.settings.width;
        config.window.height = cast app.settings.height;
        config.window.resizable = false;
        config.window.title = cast app.settings.title;

        return config;

    } //config

    override function ready():Void {

        // Background color
        Luxe.renderer.clear_color.rgb(App.app.settings.background);

        // Camera size
        Luxe.camera.size = new luxe.Vector(App.app.settings.width, App.app.settings.height);

        App.app.backend.emitReady();

    } //ready

    override function update(delta:Float):Void {

        App.app.backend.emitUpdate(delta);

    } //update

}
import { serialize, observe, action, compute, files, autorun, ceramic, keypath, Model } from 'utils';
import Scene from './Scene';
import UiState from './UiState';
import * as fs from 'fs';
import * as electron from 'electron';
import { context } from 'app/context';

class Project extends Model {

/// Properties

    /** Related scene */
    @observe @serialize scene:Scene;

    /** Project error */
    @observe error?:string;

    /** Project name */
    @observe @serialize name?:string;

/// UI State

    @observe @serialize ui:UiState;

/// Assets

    /** Assets path */
    @observe @serialize assetsPath?:string;

    /** All assets */
    @observe allAssets?:Array<string>;

    /** All asset directories */
    @observe allAssetDirs?:Array<string>;

    /** All assets by name */
    @observe allAssetsByName?:Map<string, Array<string>>;

    /** All asset directories */
    @observe allAssetDirsByName?:Map<string, Array<string>>;

    /** Image assets */
    @observe imageAssets?:Array<{name:string, constName:string, paths:Array<string>}>;

    /** Text assets */
    @observe textAssets?:Array<{name:string, constName:string, paths:Array<string>}>;

    /** Sound assets */
    @observe soundAssets?:Array<{name:string, constName:string, paths:Array<string>}>;

    /** Font assets */
    @observe fontAssets?:Array<{name:string, constName:string, paths:Array<string>}>;

/// Lifecycle

    constructor(id?:string) {

        super(id);

        // Update asset info from assets path
        //
        autorun(() => {

            let electronApp = electron.remote.require('./app.js');
            electronApp.assetsPath = this.assetsPath;

            if (!this.assetsPath || !fs.existsSync(this.assetsPath) || !fs.statSync(this.assetsPath).isDirectory()) {
                this.imageAssets = null;
                this.textAssets = null;
                this.soundAssets = null;
                this.fontAssets = null;
                this.allAssets = null;
                this.allAssetDirs = null;
                this.allAssetsByName = null;
                this.allAssetDirsByName = null;
                return;
            }

            if (!context.ceramicReady) {
                this.imageAssets = [];
                this.textAssets = [];
                this.soundAssets = [];
                this.fontAssets = [];
                this.allAssets = [];
                this.allAssetDirs = [];
                this.allAssetsByName = new Map();
                this.allAssetDirsByName = new Map();
                return;
            }

            let rawList = files.getFlatDirectory(this.assetsPath);

            ceramic.send({
                type: 'assets/lists',
                value: {
                    list: rawList
                }
            }, (message) => {
                
                this.imageAssets = message.value.images;
                this.textAssets = message.value.texts;
                this.soundAssets = message.value.sounds;
                this.fontAssets = message.value.fonts;

                this.allAssets = message.value.all;
                this.allAssetDirs = message.value.allDirs;

                this.allAssetsByName = new Map();
                for (let key in message.value.allByName) {
                    if (message.value.allByName.hasOwnProperty(key)) {
                        this.allAssetsByName.set(key, message.value.allByName[key]);
                    }
                }

                this.allAssetDirsByName = new Map();
                for (let key in message.value.allDirsByName) {
                    if (message.value.allDirsByName.hasOwnProperty(key)) {
                        this.allAssetDirsByName.set(key, message.value.allDirsByName[key]);
                    }
                }

            });

        });

        // Update data from ceramic (haxe)
        ceramic.listen('set/*', (message) => {

            let [, key] = message.type.split('/');

            // Change UI
            if (key.startsWith('ui.')) {
                keypath.set(this.ui, key.substr(3), message.value);
            }
            // Change Scene Item
            else if (key.startsWith('scene.item.')) {
                if (this.scene == null || this.scene.items == null) return;

                let name = key.substr(11);
                let item = this.scene.itemsByName.get(name);

                if (item != null) {
                    for (let k in message.value) {
                        if (message.value.hasOwnProperty(k)) {
                            keypath.set(item, k, message.value[k]);
                        }
                    }
                }
            }

        });

        // Update data from ceramic (haxe)
        ceramic.listen('scene-item/delete', (message) => {

            let name = message.value.name;
            let item = this.scene.itemsByName.get(name);

            if (item != null) {

                if (this.ui.selectedItemName === name) {
                    this.ui.selectedItemName = null;
                }

                this.scene.items.splice(
                    this.scene.items.indexOf(item),
                    1
                );
                item = null;
            }

        });

    } //constructor

/// Public API

    @action createWithName(name:string) {

        // Set name
        this.name = name;

        // Set scene
        let scene = new Scene('scene');
        scene.name = 'scene';
        scene.data = new Map();
        scene.width = 320;
        scene.height = 568;
        this.scene = scene;

        // Set UI state
        this.ui = new UiState('ui');

    } //createWithName

    @action chooseAssetsPath() {

        let path = files.chooseDirectory();
        if (path != null) {
            this.assetsPath = path;
        }

    } //chooseAssetsDirectory

} //Project

export default Project;

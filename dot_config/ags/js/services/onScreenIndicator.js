import * as Utils from 'resource:///com/github/Aylur/ags/utils.js';
import Service from 'resource:///com/github/Aylur/ags/service.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import icons from '../icons.js';
import Brightness from './brightness.js';

class Indicator extends Service {
    static {
        Service.register(this, {
            popup: ['double', 'string'],
        });
    }

    #delay = 3000;
    #count = 0;

    /**
     * @param {number} value - 0 < v < 1
     * @param {string} icon
     */
    popup(value, icon) {
        this.emit('popup', value, icon);
        this.#count++;
        Utils.timeout(this.#delay, () => {
            this.#count--;

            if (this.#count === 0) this.emit('popup', -1, icon);
        });
    }

    speaker() {
        Utils.timeout(10, () => {
            if (!Audio.speaker) return;

            const { muted, low, medium, high, overamplified } =
                icons.audio.volume;

            if (Audio.speaker.is_muted || Audio.speaker.mute) {
                Audio.speaker.volume = 0;
                this.popup(0, muted);
                return;
            } else {
                const volume = Audio.speaker.volume;

                const volumeLevels = [
                    [101, overamplified],
                    [67, high],
                    [34, medium],
                    [1, low],
                    [0, muted],
                ];

                const volumeIcon = volumeLevels.find(
                    ([threshold]) => volume * 100 >= threshold
                )?.[1];

                this.popup(volume, volumeIcon || muted);
            }
        });
    }

    display() {
        // brightness is async, so lets wait a bit
        Utils.timeout(10, () =>
            this.popup(Brightness.screen, icons.brightness.screen)
        );
    }

    kbd() {
        // brightness is async, so lets wait a bit
        Utils.timeout(10, () =>
            this.popup(
                (Brightness.kbd * 33 + 1) / 100,
                icons.brightness.keyboard
            )
        );
    }

    connect(event = 'popup', callback) {
        return super.connect(event, callback);
    }
}

export default new Indicator();

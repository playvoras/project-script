const Discord = require("discord.js-selfbot-v13");
const { joinVoiceChannel, createAudioPlayer, createAudioResource, AudioPlayerStatus } = require('@discordjs/voice');
const fs = require('fs');
const path = require('path');
const readline = require('readline');
const { promisify } = require('util');
const ffmpeg = require('fluent-ffmpeg');

console.log("Code is running");

const client = new Discord.Client({
    intents: [
        Discord.Intents.FLAGS.GUILDS,
        Discord.Intents.FLAGS.GUILD_VOICE_STATES
    ],  
    checkUpdate: false,
});

if (!process.env.TOKEN) {
    try {
        const config = require("./config");
        global.config = {'token': config.token, 'prefix': config.prefix};
    } catch (e) {
        console.error("No config file found, create it or use environment variables.");
        process.exit(1);
    }
} else {
    if (!process.env.PREFIX) process.env.PREFIX = "$";
    global.config = {'token': process.env.TOKEN, 'prefix': process.env.PREFIX};
}

client.login(global.config.token);

client.on('ready', () => {
    console.log(`Logged in as ${client.user.tag}!`);
    details();
});

function details() {
    const rl = readline.createInterface({
        input: process.stdin,
        output: process.stdout
    });

    rl.question('Enter guild id: ', async (guildId) => {
        const guild = client.guilds.cache.get(guildId);
        if (!guild) {
            console.log("Invalid guild id");
            rl.close();
            return;
        }

        console.log(`guild name: ${guild.name}`);

        rl.question('Enter the id of the voice channel to join: ', async (voiceChannelId) => {
            if (voiceChannelId) {
                const voiceChannel = guild.channels.cache.get(voiceChannelId);
                if (!voiceChannel || voiceChannel.type !== 'GUILD_VOICE') {
                    console.log("Invalid voice channel");
                    rl.close();
                    return;
                }
                console.log(`Joined voice channel: ${voiceChannel.name}`);
            } else {
                const user = await client.users.fetch(client.user.id);
                const member = await guild.members.fetch(user);
                const voiceChannel = member.voice.channel;
                if (!voiceChannel || voiceChannel.type !== 'GUILD_VOICE') {
                    console.log("Not in a voice channel.");
                    rl.close();
                    return;
                }
                console.log(`Joined voice channel: ${voiceChannel.name}`);
            }

            rl.question('Enter the path to the audio file: ', (audioPath) => {
                handling(guildId, voiceChannelId, audioPath);
                rl.close();
            });
        });
    });
}

async function handling(guildId, voiceChannelId, audioPath) {
    audioPath = path.resolve(audioPath);

    if (!fs.existsSync(audioPath)) {
        console.log("The provided file path does not exist");
        return;
    }

    const duration = await getAudioDuration(audioPath);
    if (duration !== null) {
        console.log(`audio duration: ${duration.minutes} minutes, ${duration.seconds} seconds, ${duration.milliseconds} milliseconds`);
    }

    const guild = client.guilds.cache.get(guildId);
    if (!guild) {
        console.log("Invalid guild id");
        return;
    }

    const user = await client.users.fetch(client.user.id);
    const member = await guild.members.fetch(user);

    let voiceChannel;

    if (voiceChannelId) {
        voiceChannel = guild.channels.cache.get(voiceChannelId);
    } else {
        voiceChannel = member.voice.channel;
    }

    if (!voiceChannel || voiceChannel.type !== 'GUILD_VOICE') {
        console.log("Invalid voice channel");
        return;
    }

    try {
        const connection = joinVoiceChannel({
            channelId: voiceChannel.id,
            guildId: voiceChannel.guild.id,
            adapterCreator: voiceChannel.guild.voiceAdapterCreator,
        });

        player(audioPath, connection);

    } catch (error) {
        console.error(error);
        console.log("An error occurred");
    }
}

async function getAudioDuration(audioPath) {
    try {
        const metadata = await promisify(ffmpeg.ffprobe)(audioPath);
        const durationSeconds = metadata.format.duration;
        const minutes = Math.floor(durationSeconds / 60);
        const seconds = Math.floor(durationSeconds % 60);
        const milliseconds = Math.floor((durationSeconds - Math.floor(durationSeconds)) * 1000);
        return { minutes, seconds, milliseconds };
    } catch (error) {
        console.error("Error getting audio duration:", error);
        return null;
    }
}

async function player(audioPath, connection) {
    const player = createAudioPlayer();
    const resource = createAudioResource(fs.createReadStream(audioPath));
    player.play(resource);
    connection.subscribe(player);

    player.on(AudioPlayerStatus.Playing, () => {
        console.log(`Playing audio: ${audioPath}`);
    });

    player.on(AudioPlayerStatus.Idle, () => {
        console.log('Audio finished playing.');
        connection.destroy();
    });

    player.on('error', error => {
        console.error(error);
    });
}

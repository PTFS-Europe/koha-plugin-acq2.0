const fs = require('fs')
const path = require('path')

const identifyPluginFile = (file) => {
    const pluginFile = fs.readFileSync(file, 'utf8')
    const fileByLine = pluginFile.split(/\r?\n/)

    let pluginIdentified = false
    fileByLine.forEach(line => {
        if(line.includes("Koha::Plugins::Base")){
            pluginIdentified = true
        }   
    })
    return pluginIdentified
}

const collectPluginFiles = (fullPath) => {
    let files = [] 
    fs.readdirSync(fullPath).forEach(file => { 
        const absolutePath = path.join(fullPath, file) 
        if (fs.statSync(absolutePath).isDirectory()) { 
            const filesFromNestedFolder = collectPluginFiles(absolutePath) 
            filesFromNestedFolder && filesFromNestedFolder.forEach(file => { 
                files.push(file) 
            }) 
        } else {
            return files.push(absolutePath)
        }
    })
    return files
}

const pluginFiles = collectPluginFiles('./Koha')

let pluginFilePath
pluginFiles.forEach(file => {
    const pluginFile = identifyPluginFile(file)
    if(pluginFile) {
        pluginFilePath = file
    }
})
if(!pluginFilePath) return console.log('No plugin file found')

const cliInput = process.argv.slice(2)[0]

if(cliInput === 'filename') {
    const filename = pluginFilePath.replace(/^.*[\\\/]/, '').toLowerCase()
    const removeFileExtension = path.parse(filename).name
    const kpzFileName = `koha-plugin-${removeFileExtension}.kpz`
    console.log(kpzFileName)
}
if(cliInput === 'version') {
    const pluginFile = fs.readFileSync(pluginFilePath, 'utf8')
    const fileByLine = pluginFile.split(/\r?\n/)
    
    let versionNumberIdentified
    fileByLine.forEach((line, index)=> {
        if(line.includes("our $VERSION")){
            versionNumberIdentified = index
        }
    })
    
    if(!versionNumberIdentified) return console.log('No version found') 
    if(versionNumberIdentified) {
        const regex = /"(.*?)"/
        const findVersionNumber = regex.exec(fileByLine[versionNumberIdentified])
        const pluginVersion = findVersionNumber[1]
        console.log(`v${pluginVersion}`)
    }
}

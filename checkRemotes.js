const checkType = process.argv[2]

const getFormattedRemotes = (input) => {
    const numberOfRemotes = input.length
    const remotes = []

    for(let i = 0; i < numberOfRemotes; i = i + 3) {
        const [remote, url, type] = input.slice(i, i + 3)
        remotes.push({
            remote,
            url,
            type
        })
    }

    const validRemotes = remotes.filter(remote => remote.type === '(push)').reduce((result, remote) => {
        if(remote.url !== 'git@github.com:PTFS-Europe/koha-plugin-template.git' && 
        remote.url !== 'https://github.com/PTFS-Europe/koha-plugin-template.git') {
            result.push(remote)
        }
        return result
    }, [])

    return validRemotes
}

if(checkType === 'check') {
    const cliInput = process.argv.slice(3)

    const validRemotes = getFormattedRemotes(cliInput)

    if(validRemotes.length === 0) console.log('No valid remotes')
    if(validRemotes.length === 1) return console.log(validRemotes[0].remote)

    if(validRemotes.length > 1) console.log('Multiple remotes available')
}
if(checkType === 'validate') {
    const response = process.argv.slice(3, 4)[0].split('-')[0]
    const remoteList = process.argv.slice(4)

    const validRemotes = getFormattedRemotes(remoteList).map(i => i.remote)

    const checkRemoteIsValid = validRemotes.indexOf(response)

    if(checkRemoteIsValid > -1) return console.log(response)
    if(checkRemoteIsValid === -1) return console.log('Invalid')
}
if(checkType === 'provide') {
    const cliInput = process.argv.slice(3)

    const validRemotes = getFormattedRemotes(cliInput)

    const remoteStrings = validRemotes.map(remote => {
        return `${remote.remote}-${remote.url}`
    })

    console.log(...remoteStrings)
}


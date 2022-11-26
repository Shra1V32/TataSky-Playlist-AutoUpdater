            # Copyright (C) 2022 Shra1V32 <namanageshwar@outlook.com>
            cd .. && sleep 30s
            cat "$branch_name.json" > userDetails.json
            python3 utils.py ${playlist_args}
            git clone ${gist_url}
            rm ${dir}/allChannelPlaylist.m3u
            mv *.m3u ${dir}/
            cd ${dir}
            git add .
            git commit --amend -m "Playlist has been updated"
            git push -f

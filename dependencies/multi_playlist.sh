            cd ..
            cat "$branch_name.json" > userDetails.json
            ./script.exp
            git clone ${gist_url}
            rm ${dir}/allChannelPlaylist.m3u
            mv *.m3u ${dir}/
            cd ${dir}
            git add .
            git commit --amend -m "Playlist has been updated"
            git push -f

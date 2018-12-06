

echo "The Entity split script is starting now! GET PUMPED!"


read -r -p "Does the entityCentricSplit_$(date --iso-8601)/ folder exist? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
	read -r -p "Would you like to clear the directory? [y/N] " responseY
	if [[ "$responseY" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		echo "Removing existing configuration..."
		rm -r entityCentricSplit_$(date --iso-8601)/
	fi
	mkdir  entityCentricSplit_$(date --iso-8601)/
else
	echo "Creating folder..."
	mkdir  entityCentricSplit_$(date --iso-8601)/
fi


echo "Recreating Datahub directories..."
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do mkdir entityCentricSplit_$(date --iso-8601)/$line; done

echo "Recreating SAND directories..."
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do mkdir entityCentricSplit_$(date --iso-8601)/$line/svi-sand; done


echo "Recreating Feature directories..."
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do mkdir entityCentricSplit_$(date --iso-8601)/$line/feature; done
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do mkdir entityCentricSplit_$(date --iso-8601)/$line/feature/entity_level_rules; done

echo "Splitting Datahub Configuration into entities..."
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do grep -Zlr $line datahub/. | xargs -0 tar -pc | tar -pxi --directory=entityCentricSplit_$(date --iso-8601)/$line/; done

echo "Splitting SAND Configuration into entities..."
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do cp svi-sand/$line.json entityCentricSplit_$(date --iso-8601)/$line/svi-sand/; done

echo "Splitting Feature Configuration into entities..."
for line in $(cat Entities.csv | sed 's/\,/\n/g'); do cp -r feature/entity_level_rules/$line entityCentricSplit_$(date --iso-8601)/$line/feature/entity_level_rules/; done

read -r -p "Would you like to move entityCentricSplit_$(date --iso-8601) into History folder? [y/N] " responseY
	if [[ "$responseY" =~ ^([yY][eE][sS]|[yY])+$ ]]
	then
		read -r -p "Does the History folder exist? [y/N] " responseY
			if [[ "$responseY" =~ ^([yY][eE][sS]|[yY])+$ ]]
			else
			then
				echo "Creating History folder"
				mkdir -p History
			fi
		mv -f entityCentricSplit_$(date --iso-8601) History
	fi


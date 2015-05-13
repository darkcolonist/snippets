# @author: Christian Noel Reyes <darkcolonist@gmail.com>
# @date: 2015-05-13
# @description: data / table-per table migration script.
# @disclaimer: 
#   source and target databases must have the same table structure for this script to work with no issues
#   tested with mysql 5.1 (client)

# usage:
# bash migrate.sh --shost <source host> --sdb <source database> --suser <source username> --spass <source password>\
#   --thost <target host> --tdb <target database> --tuser <target username> --tpass <target password>\
#   --limit 10000;
# 
# example:
# bash migrate.sh --shost localhost --sdb test_db1_s --suser root --spass mypassword\
#   --thost localhost --tdb test_db1_t --tuser root --tpass mypassword\
#   --limit 10000;

# default arguments { 
migratION_shost="localhost";
migratION_sdb="unknown";
migratION_suser="unknown";
migratION_spass="unknown";
migratION_sport="3306";
migratION_thost="localhost";
migratION_tdb="unknown";
migratION_tuser="unknown";
migratION_tpass="unknown";
migratION_tport="3306";
migratION_limit="10000";
#  } default arguments

# parse arguments {
for ((i=1;i<=$#;i++));
do

    # master/host details {
    if [ ${!i} = "--shost" ]
    then ((i++))
        migratION_shost=${!i};

    elif [ ${!i} = "--sdb" ];
    then ((i++))
        migratION_sdb=${!i};

    elif [ ${!i} = "--suser" ];
    then ((i++))
        migratION_suser=${!i};

    elif [ ${!i} = "--spass" ];
    then ((i++))
        migratION_spass=${!i};
    # } master details

    # slave/target details {
    elif [ ${!i} = "--thost" ]
    then ((i++))
        migratION_thost=${!i};

    elif [ ${!i} = "--tdb" ];
    then ((i++))
        migratION_tdb=${!i};

    elif [ ${!i} = "--tuser" ];
    then ((i++))
        migratION_tuser=${!i};

    elif [ ${!i} = "--tpass" ];
    then ((i++))
        migratION_tpass=${!i};
    # } slave/target details
    
    elif [ ${!i} = "--limit" ];
    then ((i++))
        migratION_limit=${!i};
    fi

done;
# } parse arguments
iteration=0;

echo "process initiating...";

mysql --skip-column-names --silent -P$migratION_sport -h$migratION_shost -u$migratION_suser -p$migratION_spass $migratION_sdb --execute="SHOW TABLES;" | while read -r a_table ; do
  iteration=$((iteration+1))

  echo "[$iteration] > exporting from $migratION_shost.$migratION_sdb.$a_table";
  mysqldump --replace --skip-extended-insert --single-transaction --no-create-db --no-create-info -P$migratION_sport -h$migratION_shost -u$migratION_suser -p$migratION_spass --where="1=1 ORDER BY id DESC LIMIT $migratION_limit" $migratION_sdb $a_table > $migratION_sdb.$a_table.sql

  echo "[$iteration] < importing into $migratION_thost.$migratION_tdb.$a_table";
  mysql -P$migratION_tport -h$migratION_thost -u$migratION_tuser -p$migratION_tpass $migratION_tdb < $migratION_sdb.$a_table.sql;

  rm $migratION_sdb.$a_table.sql;

  # sleep necessary for freeing up memory and/or cpu proc (uncomment this if and only if necessary)
  # sleep .25
done;

echo "process ended!";

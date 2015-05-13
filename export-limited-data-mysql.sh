# ==== rev 1: insert ignore into (for empty databases / new data) ====

# usage: bash export10k.sh database user password 10000
# $1 = database
# $2 = username
# $3 = password
# $4 = num records (recommended: 10000)
mysql --skip-column-names --silent -u$2 -p$3 $1 --execute="SHOW TABLES;" | while read -r line ; do
                echo "Processing: $line"
                mysqldump --insert-ignore --skip-extended-insert --single-transaction --no-create-db --no-create-info -u$2 -p$3 --where="1=1 ORDER BY id DESC LIMIT $4" $1 $line > $1.$line.sql
                sleep .25
done;

echo "compressing sql files into $1.tar.gz";
tar cvzf $1.tar.gz $1*sql;

echo "deleting sql files...";
rm $1*sql;
echo "Complete!";

# ==== rev 2: replace instead of insert (for databases with existing / outdated data) ====

# usage: bash export10k.sh database user password 10000
# $1 = database
# $2 = username
# $3 = password
# $4 = num records (recommended: 10000)
mysql --skip-column-names --silent -u$2 -p$3 $1 --execute="SHOW TABLES;" | while read -r line ; do
                echo "Processing: $line"
                mysqldump --replace --skip-extended-insert --single-transaction --no-create-db --no-create-info -u$2 -p$3 --where="1=1 ORDER BY id DESC LIMIT $4" $1 $line > $1.$line.sql
                sleep .25
done;

echo "compressing sql files into $1.tar.gz";
tar cvzf $1.tar.gz $1*sql;

echo "deleting sql files...";
rm $1*sql;
echo "Complete!";

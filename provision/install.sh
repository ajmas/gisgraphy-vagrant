export GISGRAPHY_RELEASE="gisgraphy-4.0-beta1"
export LANGUAGE="en_US.UTF-8"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

echo "INFO Installing tools we depend on"

apt-get update
apt-get -y install language-pack-en
apt-get -y install debconf-utils
apt-get -y install postgresql
apt-get -y install postgresql-contrib
apt-get -y install postgresql-9.1-postgis
apt-get -y install unzip
apt-get -y install openjdk-7-jre
apt-get -y install wget

# Fetch gisgraphy if we don't yet have it
if [ ! -f "/vagrant/provision/gisgraphy/${GISGRAPHY_RELEASE}.zip" ]; then
    echo "INFO Fetching ${GISGRAPHY_RELEASE}"
    cd /vagrant/provision/gisgraphy/
    wget -nv "http://download.gisgraphy.com/releases/${GISGRAPHY_RELEASE}.zip"
fi

echo "INFO Setting up postgres"

sudo -u postgres pgsql -f /vagrant/provision/template.sql

sudo -u postgres createdb template_postgis -T 'template1'
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
sudo -u postgres psql -d template_postgis -f /usr/share/postgresql/9.1/contrib/postgis_comments.sql
sudo -u postgres createdb gisgraphy -T 'template_postgis'
sudo -u postgres psql -c "CREATE USER dbuser WITH PASSWORD 'db'"
sudo -u postgres psql -c "GRANT ALL ON DATABASE gisgraphy TO dbuser"

echo "INFO Setting gisgraphy"

unzip "/vagrant/provision/gisgraphy/${GISGRAPHY_RELEASE}.zip" -d /home/vagrant/

export PGPASSWORD=db
cd "/home/vagrant/${GISGRAPHY_RELEASE}"
psql -U dbuser -h 127.0.0.1 -d gisgraphy -f sql/create_tables.sql
psql -U dbuser -h 127.0.0.1 -d gisgraphy -f sql/insert_users.sql

cp /vagrant/provision/jdbc.properties "/home/vagrant/${GISGRAPHY_RELEASE}/webapps/ROOT/WEB-INF/classes/"
chmod +x *.sh
# mkdir run
chown -R vagrant "/home/vagrant/${GISGRAPHY_RELEASE}"
./launch.sh &
echo "Completed provisiong"
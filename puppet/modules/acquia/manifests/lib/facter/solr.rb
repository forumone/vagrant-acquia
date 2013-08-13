# Check to see if the solr directory exists so the acquia::solr class doesn't re-download the archive 
#
#
#

require 'facter'
Facter.add(:acquia_solr) do
  setcode do
    File.exist?('/opt/apache-solr-3.6.2')
  end
end

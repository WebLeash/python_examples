import csv
 
def readMyFile(filename):
    system = []
    itam_id = []
    version = []
    env = []
    dep_date = []
    hosts = []
	  
    with open(filename) as csvDataFile:
        csvReader = csv.reader(csvDataFile)
        for row in csvReader:
            system.append(row[0])
            itam_id.append(row[1])
            version.append(row[2])
            env.append(row[3])
            dep_date.append(row[4])
            hosts.append(row[5])
		       
    return system,itam_id,version,env,dep_date,hosts
							    
					     
system,itam_id,version,env,dep_date,hosts = readMyFile('input.csv')
							      
print("system %r" % system[6])
print("itam_id %d" % int(itam_id[6]))
print("version %r" % version[6])
print("env %r" % env[6])
print("dep_date %r" % dep_date[6])
print("hosts %r" % hosts[0:])
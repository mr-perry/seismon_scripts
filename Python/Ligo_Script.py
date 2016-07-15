#!/Users/mrperry/anaconda/bin/python
def read_LIGO(LIGO_file):
	import pandas as pd
	import numpy as np
	from astropy.time import Time
	import matplotlib.pyplot as plt
	cols = ["EqGPStime","Mag","PgpsTime","SgpsTime","r2","r35","r5","pgm","lbt","ubt","lat","lon","dist","depth","pgvgpstime","pgv","pgagpstime","pga","pgdgpstime","pgd","locklossflag","locklossgpstime"]
	# Load LHO Data and convert GPS time to datetime objects
	data = pd.read_csv(LIGO_file, sep=' ',names=cols,skiprows=0, na_values='NaN')
	data['EqGPStime'] = Time(data['EqGPStime'],scale='tai',format='gps')
	data['PgpsTime'] = Time(data['PgpsTime'],scale='tai',format='gps')
	data['SgpsTime'] = Time(data['SgpsTime'],scale='tai',format='gps')
	data['r2'] = Time(data['r2'],scale='tai',format='gps')
	data['r35'] = Time(data['r35'],scale='tai',format='gps')
	data['r5'] = Time(data['r5'],scale='tai',format='gps')
	data['pgvgpstime'] = Time(data['pgvgpstime'],scale='tai',format='gps')
	data['pgagpstime'] = Time(data['pgagpstime'],scale='tai',format='gps')
	data['pgdgpstime'] = Time(data['pgdgpstime'],scale='tai',format='gps')
	for ii in range(len(data)):
		data['EqGPStime'][ii].format='datetime'
		data['PgpsTime'][ii].format='datetime'
		data['SgpsTime'][ii].format='datetime'
		data['r2'][ii].format='datetime'
		data['r35'][ii].format='datetime'
		data['r5'][ii].format='datetime'
		data['pgvgpstime'][ii].format='datetime'
		data['pgagpstime'][ii].format='datetime'
		data['pgdgpstime'][ii].format='datetime'
	Output = data[['EqGPStime','lat','lon','depth','Mag']]	
	Output_Str = str("EQ_Info_")+str(LIGO_file)
	Output.to_csv(Output_Str,sep=',')
	return data

def plot_TotalLoss(data):
	import numpy as np
	import pandas as pd
	import matplotlib.pyplot as plt
	TotalLoss = data[data.locklossflag == 2]
	fig = plt.figure()
	plt.plot(TotalLoss.EqGPStime,TotalLoss.Mag,'r.')
	fig.show()

def main():
	LHO = read_LIGO('LHO_analysis_locks.txt')
	LLO = read_LIGO('LLO_analysis_locks.txt')
#	plot_TotalLoss(LHO)

main()


#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <assert.h>

int main (int argc, char **argv){
	int bufsize=8192;
	char *infile=NULL, *ofile=NULL;
	void *ibuf, *obuf;
	FILE *ifp, *ofp;
	char line[8192];
	int llen,begyear=1890,endyear=2008;
	int *year, i, yearlen, yeari;

	if (argc == 4){
	    bufsize = atoi(argv[3]);
	}

	infile = argv[1];
	ofile = argv[2];

	/*printf("infile: %s\nofile %s\nbufsize %d\n",infile,ofile,bufsize);*/

	ibuf = malloc(bufsize);
	obuf = malloc(bufsize);
	assert(ibuf!=NULL && obuf!=NULL);

	if (strcmp(infile,"-")==0)
	    ifp = stdin;
	else
	    ifp = fopen(infile,"r");

	if (strcmp(ofile,"-")==0)
	    ofp = stdout;
	else
	    ofp = fopen(ofile,"w+");

	assert(ifp != NULL && ofp != NULL);

	assert(!setvbuf(ifp,ibuf,_IOFBF,bufsize));
	assert(!setvbuf(ofp,obuf,_IOFBF,bufsize));

	year = calloc(endyear-begyear+1,sizeof(int));
	yearlen = endyear-begyear+1;
	assert(year);

	char *curtok,*curyr,*curcnt;
	char *seentok=NULL;
	seentok = calloc(8192,sizeof(char));
	assert(seentok);

	while(fgets(line,8192,ifp)){
	    llen = strlen(line);
	    line[llen] = '\0';
	    curtok = strtok(line,"\t");
	    curyr = strtok(NULL,"\t");
	    curcnt = strtok(NULL,"\t");
	    if (strcmp(seentok,"")!=0  && strcmp(seentok,curtok)!= 0){
		fprintf(ofp,"%s\t",seentok);
		for (i = 0; i < yearlen; i++){
		    fprintf(ofp,"%d",year[i]);
		    if (i != (yearlen-1))
			fputc(' ',ofp);
		}
		fputc('\n',ofp);
		bzero(year,yearlen*sizeof(int));
	    }
	    strcpy(seentok,curtok);
	    yeari = atoi(curyr);
	    if (yeari >= begyear)
		year[yeari-begyear] = atoi(curcnt);
	}
	fprintf(ofp,"%s\t",seentok);
	for (i = 0; i < yearlen; i++){
	    fprintf(ofp,"%d",year[i]);
	    if (i != (yearlen-1))
		fputc(' ',ofp);
	}
	fputc('\n',ofp);
	fclose(ifp);
	fclose(ofp);
	return 0;
}


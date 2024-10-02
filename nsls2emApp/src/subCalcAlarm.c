#include <registryFunction.h>
#include <subRecord.h>
#include <aSubRecord.h>
#include <menuFtype.h>
#include <dbDefs.h>
#include <stdio.h>
#include <errlog.h>
#include <epicsExport.h>
#include <string.h>

//#include <asynNDArrayDriver.h>


int pdu_subDebug = 1;

#define	NOFBPM	1


static long subCalcInit(subRecord* prec) 
{
	if (pdu_subDebug)
        	printf("Record %s called subCalcInit(%p)\n",prec->name, (void*) prec);

	return 0; 
}

static long subCalcAlarm(subRecord *prec) 
{
	int noAlarmCount = 0;
	int minorAlarmCount = 0;
	int majorAlarmCount = 0;
	int invalidAlarmCount = 0;
	double* pvalue = &prec->a;
	DBLINK* plink = &prec->inpa;

	int nOfbpm = (int)prec->k;
	int i = 0, n = 0;

	
	for (i = 0; i < nOfbpm; i++, pvalue++, plink++) 
	{
		//printf("%d, %d calc, conn is %d\n", nOfbpm, i+1, (int)*pvalue);

		if(DB_LINK == plink->type || CA_LINK == plink->type)
		{
			n++;
	        	if(*pvalue == 0)
        	    		noAlarmCount += 1;
	        	else if(*pvalue == 1)
        			minorAlarmCount += 1;
			else if(*pvalue == 2)
        	    		majorAlarmCount += 1;
			else if(*pvalue == 3)
            			invalidAlarmCount += 1;
		}
	}
		
	/* define how many bpm's alarm count ? for BPM if any bpm cause alarm it display alarm */
	if(majorAlarmCount >= 1)
        	prec->val = 2;
	else if(minorAlarmCount >= 1)
        	prec->val = 1;
	else if(invalidAlarmCount >= 1)
        	prec->val = 3;
	else if(noAlarmCount >= n)
        	prec->val = 0;

	return 0;
}





static long subAlarmCalcInit(subRecord* prec) 
{
	if (pdu_subDebug)
        	printf("Record %s called subAlarmCalcInit(%p)\n",prec->name, (void*) prec);

	return 0; 
}

static long subAlarmCalcProc(subRecord *prec) 
{
	int noAlarmCount = 0;
	int minorAlarmCount = 0;
	int majorAlarmCount = 0;
	int invalidAlarmCount = 0;
	int tempVal = 0;
	double* pvalue = &prec->a;
	DBLINK* plink = &prec->inpa;
	int i = 0, n = 0;

	for (i = 0; i < 6; i++, pvalue++, plink++) 
	{
		printf("%d calc, conn is %d\n", i+1, (int)*pvalue);

		if (CA_LINK == plink->type || DB_LINK == plink->type)
		{
			if((int)(*pvalue) != 0 )
			{
				pvalue++;
				plink++;
				n++;
				tempVal = *pvalue;
/*				printf("%d PV is connected\t", i+1);
				printf("Severity is %d\n", tempVal);	*/
				if(tempVal == 0)
					noAlarmCount += 1;
			        else if(tempVal == 1)
					minorAlarmCount += 1;
	        		else if(tempVal == 2)
					majorAlarmCount += 1;
			        else if(tempVal == 3)
					invalidAlarmCount += 1;
	    		}
			else
			{
				pvalue++;
				plink++;
				invalidAlarmCount += 1;
/*				printf("%d PV is disconnected\n", i+1);*/
			}
		}
	}
	
	if(majorAlarmCount >= 2)
        	prec->val = 2;
	else if(minorAlarmCount >= 2)
        	prec->val = 1;
	else if(invalidAlarmCount >=2)
        	prec->val = 3;
	else if(noAlarmCount >= n)
        	prec->val = 0;
/*	printf("Alarm is %f\n", prec->val);*/

	return 0;
}

static long asubAlarmCalcInit(aSubRecord* prec) 
{
        if (pdu_subDebug)
                printf("Record %s called asubAlarmCalcInit(%p)\n",prec->name, (void*) prec);

        return 0; 
}

static long asubAlarmCalcProc(aSubRecord *prec) 
{
        int noAlarmCount = 0;
        int minorAlarmCount = 0;
        int majorAlarmCount = 0;
        int invalidAlarmCount = 0;
        int tempVal = 0;
        int* pvalue = (int *)prec->a;
        DBLINK* plink = &prec->inpa;
        int n = 0;
	int AlarmLevel =0;

	if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
	{
		pvalue = (int *)prec->b;
		n++;
		tempVal = pvalue[0];
		if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
	}		

	pvalue = (int *)prec->c;
	plink = &prec->inpc;
	if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->d;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->e;
	plink = &prec->inpe;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->f;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->g;
	plink = &prec->inpg;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->h;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->i;
	plink = &prec->inpi;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->j;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->k;
	plink = &prec->inpk;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->l;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->m;
        plink = &prec->inpm;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->n;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->o;
	plink = &prec->inpo;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->p;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->q;
	plink = &prec->inpq;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->r;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

	pvalue = (int *)prec->s;
        plink = &prec->inps;
        if(pvalue[0] != 0 && (CA_LINK == plink->type || DB_LINK == plink->type))
        {
                pvalue = (int *)prec->t;
                n++;
                tempVal = pvalue[0];
                if(tempVal == 0)
                                noAlarmCount += 1;
                        else if(tempVal == 1)
                                minorAlarmCount += 1;
                        else if(tempVal == 2)
                                majorAlarmCount += 1;
                        else if(tempVal == 3)
                                invalidAlarmCount += 1;
        }

        if(majorAlarmCount >= 2)
                AlarmLevel = 2;
        else if(minorAlarmCount >= 2)
                AlarmLevel = 1;
        else if(invalidAlarmCount >=2)
                AlarmLevel = 3;
        else if(noAlarmCount >= n)
                AlarmLevel = 0;
/*	printf("%d PV is connected, Alarm level is %d\n", n, AlarmLevel); */

	memcpy((int *)prec->vala, &AlarmLevel, prec->nova*sizeof(int));
        return 0;
}

/* Register these symbols for use by IOC code: */
epicsExportAddress(int, pdu_subDebug);
epicsRegisterFunction(subCalcInit);
epicsRegisterFunction(subCalcAlarm);
epicsRegisterFunction(subAlarmCalcInit);
epicsRegisterFunction(subAlarmCalcProc);
epicsRegisterFunction(asubAlarmCalcInit);
epicsRegisterFunction(asubAlarmCalcProc);


public class Scontistica {
    @AuraEnabled(cacheable=true)
    public static list <Opportunity> getDiscountedOpps(List<Opportunity> opps) {
        List<Opportunity> result = new List<Opportunity>();
        system.debug('partit');
        List<AggregateResult> accs = 
            [SELECT accountId, sum(amount)amount FROM opportunity 
             WHERE stageName = 'Closed Won' and amount>0 GROUP BY accountId];
        
        List<Sconti__mdt> sconti = [SELECT Percentuale_sconto__c, Totale_speso__c FROM Sconti__mdt ORDER BY Totale_speso__c DESC];
        
        for (Opportunity o : opps) {
            boolean found = false;
            for (AggregateResult a : accs) {
                if (a.get('accountId') == o.accountId) {
                    found = true;
                    for (Sconti__mdt sconto : sconti) {
                        if(a.get('amount') == NULL){
                            result.add(o);
                            break;
                        }
                        else if ((decimal) a.get('amount') >= sconto.Totale_speso__c) {
                            system.debug('vecchio amount ' + o.amount);
                            o.amount -= (o.amount * sconto.Percentuale_sconto__c / 100);  
                            system.debug('nuovo amount ' + o.amount);
                            result.add(o);
                            break;
                        }
                    }
                    break;
                }
            }
            if(!found){
                o.Description = 'Non ha diritto a sconto';
                result.add(o);
            }
        }
        return result;
    }
    @AuraEnabled(cacheable=true)
    public static list <Opportunity> getOpps(){ 
        list <opportunity> opps = [select id, Description, accountid, name, amount from Opportunity];
        return opps;
    }
}
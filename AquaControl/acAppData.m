//
//  acAppData.m
//  AquaControl
//
//  Created by Konstantin Chebotarev on 16/02/2014.
//  Copyright (c) 2014 Konstantin Chebotarev. All rights reserved.
//

#import "acAppData.h"

@implementation ACAppData


- (void)initAfterXMLLoad
{
/*
    self.testingOn = false;
    
    for(MCDeck *deck in self.decks){
        [deck.deck enumerateKeysAndObjectsUsingBlock:^(id key, MCQuestion *question, BOOL *stop) {
            MCCard *card = [MCCard alloc];
            card.qID = [NSString stringWithString:key];
            card.a = 0;
            card.timestamps = [[NSMutableArray alloc] init];
            for(NSMutableArray* sets in deck.modes)
            {
                [sets[1] addObject:card]; // add all cards to unknown set (set 1)
            }
        }];
        [self populateLearningSet:deck forMode:0];
        [self populateLearningSet:deck forMode:1];
        
    }
    
    self.currentDeck = self.decks[0];
    [self switchSets];
*/
 }

- (bool) readData
{
 /*   NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    if (!temp) {
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
        return false;
    }
    
    self.testingOn = [[temp objectForKey:@"Testing mode"] boolValue];
    self.currentDeck = self.decks[[[temp objectForKey:@"deck index"] intValue]];
    
    int i = 0; // deck index
    NSMutableArray *decksStats = [temp objectForKey:@"Stats"];
    for(NSMutableArray *staticDeck in decksStats){
        MCDeck *deck=self.decks[i];
        NSMutableArray *staticCardSet = staticDeck[0];
        NSMutableDictionary * allCardSet = [[NSMutableDictionary alloc] init];
        for(NSArray *c in staticCardSet)
        {
            MCCard *card = [MCCard alloc];
            card.qID = c[0];
            card.decayTime = [c[1] doubleValue];
            NSMutableArray *timestamps = [[NSMutableArray alloc] init];
            for(NSMutableArray *ts1 in c[2]){
                MCTimestamp *ts = [MCTimestamp alloc];
                ts.t = [ts1[0] doubleValue];
                ts.correct = [ts1[1] boolValue];
                [timestamps addObject:ts];
            }
            card.timestamps = timestamps;
            if(timestamps.count)
            {
                MCTimestamp *ts = timestamps[timestamps.count-1];
                card.decayPeriod = card.decayTime - ts.t;
            }
            else
                card.decayPeriod = 0.0;
            [allCardSet setObject:card forKey:card.qID];
        }
        NSMutableArray *staticModes = staticDeck[1];
        int m_idx = 0; // mode index
        for(NSMutableArray *staticMode in staticModes)
        {
            int idx = 0; // set index
            for(NSMutableArray *staticSet in staticMode)
            {
                for(NSString *qID in staticSet)
                    [deck.modes[m_idx][idx] addObject:[allCardSet objectForKey:qID]];
                idx++;
            }
            m_idx++;
        }
        i++;
    }
    [self switchSets];
    
  */
    return true;
}

- (void) writeData
{
    NSError *error;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"Data.plist"];
 
    

    NSDictionary *plistDict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects: self.fishTanks, nil]
                                                          forKeys:[NSArray arrayWithObjects: @"Stats", nil]];
    NSData *plistData = [NSPropertyListSerialization dataWithPropertyList:plistDict
                                                                   format:NSPropertyListBinaryFormat_v1_0
                                                                  options:0
                                                                    error:&error];
    if(plistData) {
        [plistData writeToFile:plistPath atomically:YES];
    }
    else {
        NSLog(@"Error: %@",error);
    }
  
}

- (void) resetAllData
{
    /*
    for(MCDeck *deck in self.decks){
        for (int idx=0; idx<2; idx++) {
            [deck.modes[idx][1] addObjectsFromArray:deck.modes[idx][0]];
            [deck.modes[idx][1] addObjectsFromArray:deck.modes[idx][3]];
            [deck.modes[idx][1] addObjectsFromArray:deck.modes[idx][2]];
            [deck.modes[idx][0] removeAllObjects];
            [deck.modes[idx][3] removeAllObjects];
            [deck.modes[idx][2] removeAllObjects];
            for(MCCard *card in deck.modes[idx][1])
            {
                card.a = 0;
                card.decayTime = 0.0;
                card.decayPeriod = 0.0;
                [card.timestamps removeAllObjects];
            }
        }
        [self populateLearningSet:deck forMode:0];
        [self populateLearningSet:deck forMode:1];
    }
    [self writeData];
     */
}

- (void) resetSets
{
    /*
    [self.currentDeck.unknownSet addObjectsFromArray:self.currentDeck.learningSet];
    [self.currentDeck.unknownSet addObjectsFromArray:self.currentDeck.forgotenSet];
    [self.currentDeck.unknownSet addObjectsFromArray:self.currentDeck.knownSet];
    [self.currentDeck.learningSet removeAllObjects];
    [self.currentDeck.forgotenSet removeAllObjects];
    [self.currentDeck.knownSet removeAllObjects];
    [self populateLearningSet:self.currentDeck forMode:(self.testingOn?1:0)];
     */
}

- (void) updateSets   // updates learning, known, forgoten sets for current deck and for current mode
{
    /*
    NSMutableArray *tempSet = [[NSMutableArray alloc] init];
    for(MCCard *card in self.currentDeck.knownSet) //check all card from Known set if they decayed
        if(card.decayTime <  [[NSDate date] timeIntervalSince1970])  //  if decay time of the card is less then current time move the card to Forgoten set
            [tempSet addObject:card];
    for(MCCard *card in tempSet)
    {
        [self.currentDeck.forgotenSet addObject:card];
        [self.currentDeck.knownSet removeObject:card];
    }
    
    [self populateLearningSet:self.currentDeck forMode:(self.testingOn?1:0)];
     */
}

- (void) moveCurrentCardToKnown
{
    /*
    if(self.currentCard)
        if(self.currentCard.isBecomeKnown) // if current card become known move it to Known set
        {
            if(![self.currentDeck.knownSet containsObject:self.currentCard])
                [self.currentDeck.knownSet addObject:self.currentCard];
            [self.currentDeck.learningSet removeObject:self.currentCard];
        }
     */
}


@end


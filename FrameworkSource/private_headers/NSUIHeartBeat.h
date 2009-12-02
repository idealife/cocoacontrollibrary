/*
 *     Generated by class-dump 3.3.1 (64 bit).
 *
 *     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2009 by Steve Nygard.
 */

#import <Cocoa/Cocoa.h>

@class NSLock, NSMutableSet, NSThread, NSView;

typedef struct {
    double _currentDate;
    double _birthDate;
    double _lastDate;
} CDAnonymousStruct7;

@interface NSUIHeartBeat : NSObject
{
    CDAnonymousStruct7 _times;
    NSLock *_drawingThreadLock;
    NSLock *_blockLock;
    NSLock *_clientsLock;
    NSMutableSet *_clients;
    NSThread *_heartBeatThread;
    NSView *_currentView;
    struct {
        unsigned int _isDrawingLocked:1;
        unsigned int _isClientsChanged:1;
        unsigned int _lockedByClient:1;
        unsigned int _sessionIsActive:1;
        unsigned int _registeredForNotifications:1;
        unsigned int _pendingClientUnlock:1;
        unsigned int _queueState:2;
        unsigned int _reserved:24;
    } _hbFlags;
}

+ (void)initialize;
+ (id)sharedHeartBeat;
+ (double)heartBeatCycle;
+ (void)setHeartBeatCycle:(double)arg1;
+ (BOOL)isHeartBeatThread;
- (BOOL)_isSpinning;
- (BOOL)_isBlocked;
- (void)_heartBeatThread:(id)arg1;
- (void)_sessionDidBecomeActive;
- (void)_sessionDidResignActive;
- (void)_registerForSessionNotifications;
- (void)_unregisterForSessionNotifications;
- (id)init;
- (void)dealloc;
- (void)addHeartBeatView:(id)arg1;
- (void)removeHeartBeatView:(id)arg1;
- (double)birthDate;
- (void)updateHeartBeatState;
- (void)disableHeartBeating;
- (void)reenableHeartBeating:(BOOL)arg1;
- (BOOL)lockFocusForView:(id)arg1 inRect:(struct CGRect)arg2 needsTranslation:(BOOL)arg3;
- (void)unlockFocusInRect:(struct CGRect)arg1;

@end

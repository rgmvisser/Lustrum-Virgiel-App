//
//  EventsViewController.m
//  23e Lustrum
//
//  Created by Ruud Visser on 2/17/13.
//  Copyright (c) 2013 Ruud Visser. All rights reserved.
//

#import "EventsViewController.h"
#import "ProgramDetailViewController.h"
#import "ProgramCell.h"
#import "Fonts.h"
@interface EventsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_events;
    Program *_currentProgram;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation EventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES];
    Program *woensdag = [[Program alloc] initEvent:@"Woensdag 8 mei" time:@"" title:@"Openingsfeest" info:@"openingsfeest"  image:[UIImage imageNamed:@"events_impuls"]];
    Program *donderdag = [[Program alloc] initEvent:@"Donderdag 9 mei" time:@"13:00" title:@"Tokolympics" info:@"sportdag"  image:[UIImage imageNamed:@"events_running"]];
    Program *donderdag2 = [[Program alloc] initEvent:@"Donderdag 9 mei" time:@"22:00"title:@"Ichbineinfahrradmacher" info:@""  image:[UIImage imageNamed:@"events_second"]];
    
    Program *vrijdag = [[Program alloc] initEvent:@"Vrijdag 10 mei" time:@"22:00"title:@"AHC Songfestival" info:@"ahc"  image:[UIImage imageNamed:@"events_music"]];
    Program *zaterdag = [[Program alloc] initEvent:@"Zaterdag 11 mei" time:@"19:00"title:@"Reunistendag" info:@"oudleden"  image:[UIImage imageNamed:@"events_reunist"]];
    Program *zaterdag2 = [[Program alloc] initEvent:@"Zaterdag 11 mei" time:@"" title:@"Lustrum theater" info:@"theater"  image:[UIImage imageNamed:@"events_theather"]];
    Program *zondag = [[Program alloc] initEvent:@"Zondag 12 mei" time:@""title:@"Familiedag" info:@"familie"  image:[UIImage imageNamed:@"events_crowd3"]];
    Program *zondag2 = [[Program alloc] initEvent:@"Zondag 12 mei" time:@""title:@"Lustrumtheater" info:@"theater"  image:[UIImage imageNamed:@"events_theather"]];
    Program *dinsdag_2 = [[Program alloc] initEvent:@"Dinsdag 14 mei" time:@"16:55"title:@"Cabaret" info:@"cabaret"  image:[UIImage imageNamed:@"events_shoes"]];
    Program *donderdag_2 = [[Program alloc] initEvent:@"Donderdag 16 mei" time:@"16:55" title:@"Businessday" info:@"business"  image:[UIImage imageNamed:@"events_work"]];
    Program *vrijdag_2 = [[Program alloc] initEvent:@"Vrijdag 17 mei" time:@"22:00" title:@"N8W8" info:@"nachtwacht"  image:[UIImage imageNamed:@"events_crowd2"]];
    
    Program *zaterdag_22 = [[Program alloc] initEvent:@"Zaterdag 18 mei" time:@"22:00" title:@"What the fuck" info:@"whatthefuck"  image:[UIImage imageNamed:@"events_crowd"]];
    Program *zondag_2 = [[Program alloc] initEvent:@"Zondag 19 mei" time:@""title:@"Virgiel doet" info:@"virgieldoet"  image:[UIImage imageNamed:@"event_lampie"]];
    Program *zondag_22 = [[Program alloc] initEvent:@"Zondag 19 mei" time:@"22:00" title:@"Eindfeest" info:@"finale"  image:[UIImage imageNamed:@"event_lights"]];
    
    _events = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithObject:woensdag],[NSArray arrayWithObjects:donderdag,donderdag2,nil],[NSArray arrayWithObject:vrijdag],[NSArray arrayWithObjects:zaterdag,zaterdag2,nil],[NSArray arrayWithObjects:zondag,zondag2,nil],[NSArray arrayWithObject:dinsdag_2],[NSArray arrayWithObject:donderdag_2],[NSArray arrayWithObject:vrijdag_2],[NSArray arrayWithObjects:zaterdag_22,nil],[NSArray arrayWithObjects:zondag_2,zondag_22,nil], nil];
    
    
	// Do any additional setup after loading the view.
}

-(int)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_events count];
}

-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_events objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProgramCell *cell = (ProgramCell *)[tableView dequeueReusableCellWithIdentifier:@"programIdentifier"];
    [cell setProgram:[[_events objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    [cell setAccessoryView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrows"]]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 37;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    [image setImage:[UIImage imageNamed:@"programma_header"]];
    [header addSubview:image];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 37)];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextColor:[UIColor colorWithRed:0.14 green:0.68 blue:0.886 alpha:1]];
    [header addSubview:label];
    Program *program = (Program *)[[_events objectAtIndex:section] objectAtIndex:0];
    [label setText:[program date]];
    [Fonts setStaticBold:label];
    
    
    return header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select");
    _currentProgram = [[_events objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showProgram" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showProgram"])
    {
        ProgramDetailViewController *desti = segue.destinationViewController;
        desti.program = _currentProgram;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

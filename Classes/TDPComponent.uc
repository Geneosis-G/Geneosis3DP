class TDPComponent extends GGMutatorComponent;

var GGGoat gMe;
var GGMutator myMut;
var StaticMeshComponent printerMesh;
var bool canSpawnTrophy;

/**
 * See super.
 */
function AttachToPlayer( GGGoat goat, optional GGMutator owningMutator )
{
	local GGProgression progression;
	local int nrOfCollectiblesFoundOnMap;
	local string mapName;

	super.AttachToPlayer(goat, owningMutator);

	if(mGoat != none)
	{
		gMe=goat;
		myMut=owningMutator;

		printerMesh.SetLightEnvironment( gMe.mesh.LightEnvironment );
		gMe.mesh.AttachComponent( printerMesh, 'Spine_01', vect(0.f, 0.f, 12.f));

		progression = class'GGEngine'.static.GetGGEngine().GetProgression();
		mapName = Locs( gMe.WorldInfo.GetMapName() );
		nrOfCollectiblesFoundOnMap = progression.GetNrOfCollectablesFoundOnMap( mapName );
		if( nrOfCollectiblesFoundOnMap >= GGGameInfo( gMe.WorldInfo.Game ).mIDsOfCollectiblesOnLevel.Length )
		{
			canSpawnTrophy=true;
		}
	}
}

function KeyState( name newKey, EKeyState keyState, PlayerController PCOwner )
{
	local GGPlayerInputGame localInput;

	if(PCOwner != gMe.Controller)
		return;

	localInput = GGPlayerInputGame( PlayerController( gMe.Controller ).PlayerInput );

	if( keyState == KS_Down )
	{
		if( localInput.IsKeyIsPressed( "GBA_Special", string( newKey ) ) )
		{
			PrintIt();
		}
	}
}

function PrintIt()
{
	local vector spawnLocation;
	local PrintedKActor prtKAct;
	local PrintedBody prtBody;
	local DynamicSMActor smactToCopy;
	local GGKAsset kAssetToCopy;
	local Pawn pawnToCopy;

	if(gMe.mGrabbedItem == none)
	{
		return;
	}

	gMe.mesh.GetSocketWorldLocationAndRotation( 'Demonic', spawnLocation );
	if(IsZero(spawnLocation))
	{
		spawnLocation=gMe.Location + (Normal(vector(gMe.Rotation)) * (gMe.GetCollisionRadius() + 30.f));
	}

	smactToCopy=DynamicSMActor(gMe.mGrabbedItem);
	pawnToCopy=Pawn(gMe.mGrabbedItem);
	kAssetToCopy=GGKAsset(gMe.mGrabbedItem);
	if(smactToCopy != none)
	{
		prtKAct = gMe.Spawn( class'PrintedKActor',,, spawnLocation,,, true);
		prtKAct.ChangeSkin(smactToCopy.StaticMeshComponent, smactToCopy.DrawScale, smactToCopy.DrawScale3D);
	}
	else if(pawnToCopy != none)
	{
		if(canSpawnTrophy && pawnToCopy.Mesh.SkeletalMesh == SkeletalMesh'goat.mesh.Goat' && Rand(100) == 0)
		{
			prtKAct = gMe.Spawn( class'PrintedKActor',,, spawnLocation,,, true);
			prtKAct.SetMassScale( 1000000.f );
			prtKAct.CollisionComponent.WakeRigidBody();
		}
		else
		{
			prtBody = gMe.Spawn( class'PrintedBody',,, spawnLocation,,, true);
			prtBody.ChangeSkin(pawnToCopy.mesh, pawnToCopy.DrawScale, pawnToCopy.DrawScale3D, GGScoreActorInterface(pawnToCopy));
		}
	}
	else if(kAssetToCopy != none)
	{
		prtBody = gMe.Spawn( class'PrintedBody',,, spawnLocation,,, true);
		prtBody.ChangeSkin(kAssetToCopy.SkeletalMeshComponent, kAssetToCopy.DrawScale, kAssetToCopy.DrawScale3D, GGScoreActorInterface(kAssetToCopy));
	}
}

defaultproperties
{
	Begin Object class=StaticMeshComponent Name=StaticMeshComp1
		StaticMesh=StaticMesh'Props_01.Mesh.WeldingEquipment_01'
		Rotation=(Pitch=0, Yaw=16384, Roll=0)
		Translation=(X=10, Y=0, Z=0)
	End Object
	printerMesh=StaticMeshComp1
}
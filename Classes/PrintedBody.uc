class PrintedBody extends GGGoat
	implements( GGScoreActorInterface )
	placeable;

/** The name displayed in a combo */
var string mScoreActorName;

/** The maximum score this bike is worth interacting with in a combo */
var int mScore;

function ChangeSkin(SkeletalMeshComponent comp, float newDrawScale, vector newDrawScale3D, GGScoreActorInterface scoreAct)
{
	local MaterialInterface mat;
	local AnimSet as;
	local int index;

	if(scoreAct != none)
	{
		mScore=scoreAct.GetScore();
		mScoreActorName=scoreAct.GetActorName();
	}

	Mesh.SetSkeletalMesh( comp.SkeletalMesh );
	Mesh.SetPhysicsAsset( comp.PhysicsAsset );
	Mesh.SetAnimTreeTemplate( comp.AnimTreeTemplate );
	foreach comp.AnimSets(as, index)
	{
		Mesh.AnimSets[index]=as;
	}
	foreach comp.Materials(mat, index)
	{
		Mesh.SetMaterial(index, mat);
	}
	SetDrawScale(newDrawScale);
	SetDrawScale3D(newDrawScale3D);

	//Fix collision
	SetRagdoll(true);

	mesh.SetLightEnvironment(mLightEnvironment);
}

function SetRagdoll( bool ragdoll )
{
	if(ragdoll && Controller == none)
	{
		mLockBones=true;
	}

	super.SetRagdoll(ragdoll);
}

/*********************************************************************************************
 SCORE ACTOR INTERFACE
*********************************************************************************************/

/**
 * Human readable name of this actor.
 */
function string GetActorName()
{
	return mScoreActorName;
}

/**
 * How much score this actor gives.
 */
function int GetScore()
{
	return mScore;
}

function PhysicalMaterial GetPhysMat()
{
	return none;
}

/*********************************************************************************************
 END SCORE ACTOR INTERFACE
*********************************************************************************************/

DefaultProperties
{
	mScore=0
	mScoreActorName="3D Copy"

	bStatic=false
	bNoDelete=false
}
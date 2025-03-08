class PrintedKActor extends GGKActor
placeable;

var DynamicLightEnvironmentComponent mLightEnvironment;

function ChangeSkin(StaticMeshComponent comp, optional float newDrawScale = 1.f, optional vector newDrawScale3D = vect(1, 1, 1))
{
	local MaterialInterface mat;
	local PrintedKActor pKa;
	local int index;

	SetStaticMesh(comp.StaticMesh, comp.Translation, comp.Rotation, comp.Scale3D);
	foreach comp.Materials(mat, index)
	{
		StaticMeshComponent.SetMaterial(index, mat);
	}
	SetDrawScale(newDrawScale);
	SetDrawScale3D(newDrawScale3D);

	//Fix collision
	pKa=Spawn(class'PrintedKActor',,, Location, Rotation, self, true);

	Destroy();
	pKa.CollisionComponent.WakeRigidBody();
}

function string GetActorName()
{
	if(StaticMeshComponent.StaticMesh == StaticMesh'3DPrinterModels.Mesh.GoldenGoat')
	{
		return "Golden Goat Statue";
	}

	return super.GetActorName();
}

DefaultProperties
{
	Begin Object name=StaticMeshComponent0
		StaticMesh=StaticMesh'3DPrinterModels.mesh.GoldenGoat'
	End Object

	bStatic=false
	bNoDelete=false
}